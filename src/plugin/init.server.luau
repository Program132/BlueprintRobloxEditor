-- Import services
local HttpService = game:GetService("HttpService")

-- Import the backend modules
local Shared = script.Parent:WaitForChild("Shared")
local Graph = require(Shared.Graph)

-- Create a new toolbar section for the plugin
local toolbar = plugin:CreateToolbar("Blueprint Editor")

-- Create a button on the toolbar (only toggles the widget open/closed)
local pluginButton = toolbar:CreateButton(
	"Edit Blueprint",
	"Open the Blueprint Editor",
	"rbxassetid://4458901886"
)

pluginButton.ClickableWhenViewportHidden = true

-- Create the docking widget plugin GUI
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	true,   -- Widget is initially enabled
	false,  -- Don't override previous enabled state
	400,    -- Float X size
	300,    -- Float Y size
	200,    -- Min Width
	150     -- Min Height
)

local widget = plugin:CreateDockWidgetPluginGui("BlueprintEditorWidget", widgetInfo)
widget.Title = "Blueprint Editor"

-- Keep the toolbar button active state in sync with the widget
local function onWidgetEnabledChanged()
	pluginButton:SetActive(widget.Enabled)
end

widget:GetPropertyChangedSignal("Enabled"):Connect(onWidgetEnabledChanged)
onWidgetEnabledChanged()

-- Toggle widget on toolbar button click
pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

-- Project state
local currentProjectPath = nil
local currentGraph = Graph.new()

-- Build the widget UI

-- Top bar frame
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
topBar.BorderSizePixel = 0
topBar.Parent = widget

local topBarLayout = Instance.new("UIListLayout")
topBarLayout.FillDirection = Enum.FillDirection.Horizontal
topBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
topBarLayout.Padding = UDim.new(0, 6)
topBarLayout.Parent = topBar

local topBarPadding = Instance.new("UIPadding")
topBarPadding.PaddingLeft = UDim.new(0, 8)
topBarPadding.Parent = topBar

-- Helper: create a small action button in the top bar
local function makeTopBarButton(name, label)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 110, 0, 26)
	btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	btn.BorderSizePixel = 0
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamMedium
	btn.AutoButtonColor = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = btn

	btn.Parent = topBar
	return btn
end

local newProjectBtn  = makeTopBarButton("NewProjectBtn",  "+ New Project")
local openProjectBtn = makeTopBarButton("OpenProjectBtn", "Open Project")

-- Canvas area below the top bar
local canvas = Instance.new("Frame")
canvas.Name = "Canvas"
canvas.Size = UDim2.new(1, 0, 1, -40)
canvas.Position = UDim2.new(0, 0, 0, 40)
canvas.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
canvas.BorderSizePixel = 0
canvas.ClipsDescendants = true
canvas.Parent = widget

-- Placeholder label shown before any project is loaded
local placeholder = Instance.new("TextLabel")
placeholder.Name = "Placeholder"
placeholder.Size = UDim2.new(1, 0, 1, 0)
placeholder.BackgroundTransparency = 1
placeholder.Text = "No project open.\nUse '+ New Project' or 'Open Project' above."
placeholder.TextColor3 = Color3.fromRGB(100, 100, 100)
placeholder.TextSize = 14
placeholder.Font = Enum.Font.Gotham
placeholder.TextWrapped = true
placeholder.Parent = canvas

-- Button logic

newProjectBtn.MouseButton1Click:Connect(function()
	currentProjectPath = nil
	currentGraph = Graph.new()
	placeholder.Text = "New project created. Start adding nodes!"
	-- TODO: initialise the canvas for the new graph
end)

openProjectBtn.MouseButton1Click:Connect(function()
	-- TODO: implement file-pick and graph loading
	placeholder.Text = "Open Project -- file picker not yet implemented."
end)