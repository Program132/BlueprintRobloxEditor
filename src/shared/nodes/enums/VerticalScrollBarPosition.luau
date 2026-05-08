local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Positions = { "Right", "Left" }

local VerticalScrollBarPositionNode = {}
VerticalScrollBarPositionNode.__index = VerticalScrollBarPositionNode
setmetatable(VerticalScrollBarPositionNode, Node)

function VerticalScrollBarPositionNode.new()
	local self = Node.new("Enum VerticalScrollBarPosition", NodeType.ENUM)
	setmetatable(self, VerticalScrollBarPositionNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Position", "Right", false, Positions))
	self:addOutput(IO.Output.new("Enum", "Enum.VerticalScrollBarPosition.Right"))
	
	return self
end

function VerticalScrollBarPositionNode:toLuau()
	local selected = self:getInput("Position").Value
	self:getOutput("Enum").Value = `Enum.VerticalScrollBarPosition.{selected}`
	return ""
end

return VerticalScrollBarPositionNode
