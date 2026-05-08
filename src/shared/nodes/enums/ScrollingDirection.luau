local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Directions = { "X", "Y", "XY" }

local ScrollingDirectionNode = {}
ScrollingDirectionNode.__index = ScrollingDirectionNode
setmetatable(ScrollingDirectionNode, Node)

function ScrollingDirectionNode.new()
	local self = Node.new("Enum ScrollingDirection", NodeType.ENUM)
	setmetatable(self, ScrollingDirectionNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Direction", "XY", false, Directions))
	self:addOutput(IO.Output.new("Enum", "Enum.ScrollingDirection.XY"))
	
	return self
end

function ScrollingDirectionNode:toLuau()
	local selected = self:getInput("Direction").Value
	self:getOutput("Enum").Value = `Enum.ScrollingDirection.{selected}`
	return ""
end

return ScrollingDirectionNode
