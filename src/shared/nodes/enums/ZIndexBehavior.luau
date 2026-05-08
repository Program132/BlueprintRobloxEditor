local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Behaviors = { "Global", "Sibling" }

local ZIndexBehaviorNode = {}
ZIndexBehaviorNode.__index = ZIndexBehaviorNode
setmetatable(ZIndexBehaviorNode, Node)

function ZIndexBehaviorNode.new()
	local self = Node.new("Enum ZIndexBehavior", NodeType.ENUM)
	setmetatable(self, ZIndexBehaviorNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Behavior", "Sibling", false, Behaviors))
	self:addOutput(IO.Output.new("Enum", "Enum.ZIndexBehavior.Sibling"))
	
	return self
end

function ZIndexBehaviorNode:toLuau()
	local selected = self:getInput("Behavior").Value
	self:getOutput("Enum").Value = `Enum.ZIndexBehavior.{selected}`
	return ""
end

return ZIndexBehaviorNode
