-- Create a new toolbar section for the plugin
local toolbar = plugin:CreateToolbar("Blueprint Editor")

-- Create a button on the toolbar
local pluginButton = toolbar:CreateButton(
	"Edit Blueprint",
	"Open the Blueprint Editor",
	"rbxassetid://4458901886" -- Generic placeholder icon
)

pluginButton.ClickableWhenViewportHidden = true

-- Create the docking widget plugin GUI
local widgetInfo = DockWidgetPluginGuiInfo.new(
	Enum.InitialDockState.Float,
	true,   -- Widget is initially enabled
	false,  -- Don't override previous enabled state
	200,    -- Float X size
	300,    -- Float Y size
	150,    -- Min Width
	150     -- Min Height
)

local widget = plugin:CreateDockWidgetPluginGui("BlueprintEditorWidget", widgetInfo)
widget.Title = "Blueprint Editor"

-- Function to toggle the widget's visibility
local function onPluginButtonClicked()
	widget.Enabled = not widget.Enabled
end

pluginButton.Click:Connect(onPluginButtonClicked)

-- Make sure the button stays active if the widget is open
local function onWidgetEnabledChanged()
	pluginButton:SetActive(widget.Enabled)
end

widget:GetPropertyChangedSignal("Enabled"):Connect(onWidgetEnabledChanged)
onWidgetEnabledChanged()

print("Blueprint Editor Plugin Loaded")

-- Import the backend modules
local Shared = script.Parent:WaitForChild("Shared")
local Graph = require(Shared.Graph)

-- Import specific nodes
local EventStart = require(Shared.nodes.events.Start)
local PrintNode = require(Shared.nodes.Print)
local AddNode = require(Shared.nodes.math.Add)

print("--- STARTING BLUEPRINT SYSTEM DEMO ---")

-- 1. Create a Graph
local myGraph = Graph.new()
print("✓ Graph created")

-- 2. Create Nodes
local eventNode = EventStart.new()
eventNode:setXY(100, 100)

local addNode1 = AddNode.new()
addNode1:setXY(300, 100)

local addNode2 = AddNode.new()
addNode2:setXY(500, 100)

local printNode = PrintNode.new()
printNode:setXY(700, 100)

print("✓ Nodes created: EventStart, Add1, Add2, Print")

-- 3. Add Nodes to Graph
myGraph:add_node(eventNode)
myGraph:add_node(addNode1)
myGraph:add_node(addNode2)
myGraph:add_node(printNode)
print("✓ Nodes added to graph")

-- 4. Set up data for the first Add node (5 + 10)
local inputA1 = addNode1:getInput("A")
local inputB1 = addNode1:getInput("B")
if inputA1 then inputA1.Value = "5" end
if inputB1 then inputB1.Value = "10" end
print("✓ Add1 node inputs set: A=5, B=10")

-- 5. Set up data for the second Add node (Result + 3)
-- Note: A will receive the result from Add1, B is set to 3
local inputB2 = addNode2:getInput("B")
if inputB2 then inputB2.Value = "3" end
print("✓ Add2 node input B set: B=3 (A will come from Add1.Result)")

-- 6. Connect execution flow: EventStart -> Add1 -> Add2 -> Print
myGraph:connect_exec(eventNode, addNode1, "Exec")
myGraph:connect_exec(addNode1, addNode2, "Exec")
myGraph:connect_exec(addNode2, printNode, "Exec")
print("✓ Execution edges connected: EventStart → Add1 → Add2 → Print")

-- 7. Connect data flow: 
--    Add1.Result -> Add2.A (chain the additions)
--    Add2.Result -> Print.Value
myGraph:connect_data(addNode1, addNode2, "Result", "A")
myGraph:connect_data(addNode2, printNode, "Result", "Value")
print("✓ Data edges connected:")
print("  - Add1.Result → Add2.A")
print("  - Add2.Result → Print.Value")

-- 8. Build blocks from the graph
print("\n--- BUILDING BLOCKS ---")
local blocks = myGraph:build_blocks()
print("✓ Built " .. #blocks .. " block(s)")

for i, block in ipairs(blocks) do
	print("  Block " .. i .. ": parent = " .. block.parent_node.Title)
	print("    - " .. #block.exec_edges .. " exec edge(s)")
	print("    - " .. #block.data_edges .. " data edge(s)")
end

-- 9. Generate and display code
print("\n--- GENERATED LUAU CODE ---")
for i, block in ipairs(blocks) do
	print("-- Block " .. i .. " (from " .. block.parent_node.Title .. "):")
	local code = block:run()
	print(code)
end
print("--- END OF GENERATED CODE ---")

print("\n--- BLUEPRINT SYSTEM DEMO COMPLETED ---")
print("Expected output: print((5 + 10) + 3)")


