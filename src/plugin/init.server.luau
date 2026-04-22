-- Import backend modules
local HttpService = game:GetService("HttpService")
local Shared = script.Parent:WaitForChild("Shared")
local Graph  = require(Shared.Graph)

-- Import plugin classes
local FileManager = require(script.FileManager)

-- Import UI classes
local UI      = script.ui
local TopBar  = require(UI.TopBar)
local Canvas  = require(UI.Canvas)
local Sidebar = require(UI.Sidebar)
local Modal   = require(UI.Modal)
local ScriptModal = require(UI.ScriptModal)
local NodeMenu = require(UI.NodeMenu)
local NodeComponent = require(UI.NodeComponent)

local Nodes = {
	Start = require(Shared.nodes.events.Start),
	Print = require(Shared.nodes.Print),
	Add   = require(Shared.nodes.math.Add),
}

-- Toolbar button (toggle widget only)
local toolbar      = plugin:CreateToolbar("Blueprint Editor")
local pluginButton = toolbar:CreateButton("Edit Blueprint", "Open the Blueprint Editor", "rbxassetid://4458901886")
pluginButton.ClickableWhenViewportHidden = true

-- Docking widget
local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, false, 800, 500, 400, 300)
local widget     = plugin:CreateDockWidgetPluginGui("BlueprintEditorWidget", widgetInfo)
widget.Title     = "Blueprint Editor"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Sync toolbar button active state with widget visibility
widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	pluginButton:SetActive(widget.Enabled)
end)
pluginButton:SetActive(widget.Enabled)

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

-- Build UI (order matters for Sibling ZIndex: last created = on top)
local canvas  = Canvas.new(widget)   -- bottom layer
local sidebar = Sidebar.new(widget)  -- above canvas
local topBar  = TopBar.new(widget)   -- top layer

-- Offset canvas to the right of the sidebar
canvas:SetLeftOffset(sidebar:GetWidth())

local newProjectBtn  = topBar:AddButton("NewProjectBtn",  "+ New Project")
local openProjectBtn = topBar:AddButton("OpenProjectBtn", "Open Project")
local saveProjectBtn = topBar:AddButton("SaveProjectBtn", "Save Project")

-- Initialise services
local fm           = FileManager.new(plugin)
local SETTING_KEY  = "BlueprintEditor_CurrentProject"

-- Project state
local projectActive      = false
local currentProjectName = nil
local currentProjectData = nil
local currentGraph       = Graph.new()
local visualNodes        = {}

-- ── Start a project (shared setup for new / open) ─────────────────────────────
local function activateProject(data, name)
	projectActive      = true
	currentProjectName = name or "Untitled"
	currentProjectData = data

	currentGraph = Graph.new()
	-- TODO: rebuild graph from data.nodes / data.connections

	canvas:ShowGrid()
	canvas:HidePlaceholder()

	widget.Title = "Blueprint Editor  -  " .. currentProjectName
end

-- ── Collect current project data ──────────────────────────────────────────────
local function gatherProjectData()
	return {
		name        = currentProjectName,
		nodes       = {},   -- TODO: serialise currentGraph nodes
		connections = {},   -- TODO: serialise currentGraph connections
	}
end

-- ── New Project ────────────────────────────────────────────────────────────────
newProjectBtn:OnClick(function()
	local defaultData = { name = "Untitled", nodes = {}, connections = {} }
	fm:SaveJSON(SETTING_KEY, defaultData)
	activateProject(defaultData, nil)
end)

-- ── Open Project ───────────────────────────────────────────────────────────────
openProjectBtn:OnClick(function()
	local project = fm:OpenJSON({"json"})
	if project == nil then return end

	fm:SaveJSON(SETTING_KEY, project.data)
	activateProject(project.data, project.name)
end)

-- ── Save Project ───────────────────────────────────────────────────────────────
saveProjectBtn:OnClick(function()
	if not projectActive then return end

	local data = gatherProjectData()

	-- Auto-save to Studio settings
	fm:SaveJSON(SETTING_KEY, data)

	-- Export to StringValue for manual copy
	fm:ExportToStringValue(data)

	canvas:SetPlaceholder(
		"Project saved!\n\n"
		.. "JSON exported to workspace.__BlueprintExport.\n"
		.. "Select it in Explorer and copy the Value."
	)
	task.delay(3, function()
		if projectActive then canvas:HidePlaceholder() end
	end)
end)

-- ── Sidebar: Scripts ──────────────────────────────────────────────────────────
local function onEditScript(handle)
	ScriptModal.prompt(widget, handle.data, function(updatedData)
		-- Update the data
		handle.data = updatedData
		-- Update UI
		handle.nameLabel.Text = updatedData.name
		handle.typeBtn.Text = updatedData.type == "Function" and "FUN" or (updatedData.type == "Module" and "MOD" or "DEF")
	end)
end

sidebar:OnAddScript(function()
	ScriptModal.prompt(widget, nil, function(newScriptData)
		sidebar:AddScript(newScriptData, onEditScript)
	end)
end)

-- ── Sidebar: Variables ────────────────────────────────────────────────────────
sidebar:OnAddVariable(function()
	Modal.prompt(widget, "New Variable", "Variable name...", function(varName)
		sidebar:AddVariable(varName)
	end)
end)

-- ── Canvas: Left Click ─────────────────────────────────────────────────────────
canvas:OnLeftClick(function()
	print("[Blueprint] Left click callback fired! projectActive:", projectActive)
	if not projectActive then return end
	
	-- Deselect all nodes
	local count = 0
	for _, v in ipairs(visualNodes) do
		v:Deselect()
		count += 1
	end
	print("[Blueprint] Deselected", count, "nodes")
end)

-- ── Canvas: Right Click Menu & Panning ────────────────────────────────────────
canvas:OnRightClick(function(position)
	if not projectActive then return end
	
	NodeMenu.prompt(widget, position, function(nodeId)
		local nodeClass = Nodes[nodeId]
		if not nodeClass then return end
		
		local nodeInstance = nodeClass.new()
		
		-- Place it under the mouse cursor in the canvas
		-- We need to offset the screen position by the canvas absolute position and pan offset
		local canvasPos = canvas:GetInstance().AbsolutePosition
		local panOffset = canvas:GetPanOffset()
		local relativeX = position.X - canvasPos.X - panOffset.X
		local relativeY = position.Y - canvasPos.Y - panOffset.Y
		
		nodeInstance:editPosition(Vector2.new(relativeX, relativeY))
		currentGraph:add_node(nodeInstance)
		
		-- Render it
		local visualNode = NodeComponent.new(canvas:GetNodeContainer(), nodeInstance)
		table.insert(visualNodes, visualNode)
		
		visualNode.OnSelect.Event:Connect(function()
			for _, v in ipairs(visualNodes) do
				if v ~= visualNode then
					v:Deselect()
				end
			end
		end)
	end)
end)

-- ── Restore last project on startup ───────────────────────────────────────────
local saved = fm:LoadJSON(SETTING_KEY)
if saved then
	activateProject(saved, saved.name)
end