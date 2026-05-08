local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Options = { "Escape", "Stop" }

local SelectionBehaviorNode = {}
SelectionBehaviorNode.__index = SelectionBehaviorNode
setmetatable(SelectionBehaviorNode, Node)

function SelectionBehaviorNode.new()
	local self = Node.new("Enum SelectionBehavior", NodeType.ENUM)
	setmetatable(self, SelectionBehaviorNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Behavior", "Escape", false, Options))
	self:addOutput(IO.Output.new("Enum", "Enum.SelectionBehavior.Escape"))
	
	return self
end

function SelectionBehaviorNode:toLuau()
	local selected = self:getInput("Behavior").Value
	self:getOutput("Enum").Value = `Enum.SelectionBehavior.{selected}`
	return ""
end

return SelectionBehaviorNode
