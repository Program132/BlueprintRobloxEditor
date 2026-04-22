-- Import backend modules
local Shared = script.Parent:WaitForChild("Shared")
local Graph  = require(Shared.Graph)

-- Import plugin classes
local FileManager = require(script.FileManager)

-- Import UI classes
local UI     = script.ui
local TopBar = require(UI.TopBar)
local Canvas = require(UI.Canvas)

-- Toolbar button (toggle widget only)
local toolbar      = plugin:CreateToolbar("Blueprint Editor")
local pluginButton = toolbar:CreateButton("Edit Blueprint", "Open the Blueprint Editor", "rbxassetid://4458901886")
pluginButton.ClickableWhenViewportHidden = true

-- Docking widget
local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, false, 400, 300, 200, 150)
local widget     = plugin:CreateDockWidgetPluginGui("BlueprintEditorWidget", widgetInfo)
widget.Title     = "Blueprint Editor"

-- Sync toolbar button active state with widget visibility
widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	pluginButton:SetActive(widget.Enabled)
end)
pluginButton:SetActive(widget.Enabled)

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

-- Build UI
local topBar = TopBar.new(widget)
local canvas = Canvas.new(widget)

local newProjectBtn  = topBar:AddButton("NewProjectBtn",  "+ New Project")
local openProjectBtn = topBar:AddButton("OpenProjectBtn", "Open Project")

-- Initialise services
local fm           = FileManager.new(plugin)
local SETTING_KEY  = "BlueprintEditor_CurrentProject"

-- Project state
local currentProjectName = nil
local currentGraph       = Graph.new()

-- ── New Project ────────────────────────────────────────────────────────────────
newProjectBtn:OnClick(function()
	currentProjectName = nil
	currentGraph       = Graph.new()

	-- Clear any previously saved project from Studio settings
	fm:DeleteSetting(SETTING_KEY)

	canvas:SetPlaceholder("New project created. Start adding nodes!")
	-- TODO: render blank graph on canvas
end)

-- ── Open Project ───────────────────────────────────────────────────────────────
openProjectBtn:OnClick(function()
	local project = fm:OpenJSON({"json"})

	if project == nil then
		-- User cancelled or file was invalid (FileManager already warns)
		return
	end

	currentProjectName = project.name
	currentGraph       = Graph.new()

	-- Persist to Studio settings so it survives session restarts
	fm:SaveJSON(SETTING_KEY, project.data)

	-- TODO: rebuild graph from project.data.nodes / project.data.connections

	canvas:SetPlaceholder("Project '" .. project.name .. "' loaded!")
end)

-- ── Restore last project on startup ───────────────────────────────────────────
local saved = fm:LoadJSON(SETTING_KEY)
if saved then
	currentGraph = Graph.new()
	-- TODO: rebuild graph from saved
	canvas:SetPlaceholder("Restored last project from Studio settings.")
end