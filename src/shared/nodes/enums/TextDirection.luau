local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Directions = { "Auto", "LeftToRight", "RightToLeft" }

local TextDirectionNode = {}
TextDirectionNode.__index = TextDirectionNode
setmetatable(TextDirectionNode, Node)

function TextDirectionNode.new()
	local self = Node.new("Enum TextDirection", NodeType.ENUM)
	setmetatable(self, TextDirectionNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Direction", "Auto", false, Directions))
	self:addOutput(IO.Output.new("Enum", "Enum.TextDirection.Auto"))
	
	return self
end

function TextDirectionNode:toLuau()
	local selected = self:getInput("Direction").Value
	self:getOutput("Enum").Value = `Enum.TextDirection.{selected}`
	return ""
end

return TextDirectionNode
