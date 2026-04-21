-- Import backend modules
local Shared = script.Parent:WaitForChild("Shared")
local Graph  = require(Shared.Graph)

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

-- Project state
local currentProjectPath = nil
local currentGraph       = Graph.new()

-- Wire up buttons
newProjectBtn:OnClick(function()
	currentProjectPath = nil
	currentGraph       = Graph.new()
	canvas:SetPlaceholder("New project created. Start adding nodes!")
	-- TODO: render graph on canvas
end)

openProjectBtn:OnClick(function()
	-- TODO: implement project file loading
	canvas:SetPlaceholder("Open Project -- file picker not yet implemented.")
end)