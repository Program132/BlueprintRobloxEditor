local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Alignments = { "Top", "Center", "Bottom" }

local TextYAlignmentNode = {}
TextYAlignmentNode.__index = TextYAlignmentNode
setmetatable(TextYAlignmentNode, Node)

function TextYAlignmentNode.new()
	local self = Node.new("Enum TextYAlignment", NodeType.ENUM)
	setmetatable(self, TextYAlignmentNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Alignment", "Center", false, Alignments))
	self:addOutput(IO.Output.new("Enum", "Enum.TextYAlignment.Center"))
	
	return self
end

function TextYAlignmentNode:toLuau()
	local selected = self:getInput("Alignment").Value
	self:getOutput("Enum").Value = `Enum.TextYAlignment.{selected}`
	return ""
end

return TextYAlignmentNode
