local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Alignments = { "Left", "Right", "Center" }

local TextXAlignmentNode = {}
TextXAlignmentNode.__index = TextXAlignmentNode
setmetatable(TextXAlignmentNode, Node)

function TextXAlignmentNode.new()
	local self = Node.new("Enum TextXAlignment", NodeType.ENUM)
	setmetatable(self, TextXAlignmentNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Alignment", "Left", false, Alignments))
	self:addOutput(IO.Output.new("Enum", "Enum.TextXAlignment.Left"))
	
	return self
end

function TextXAlignmentNode:toLuau()
	local selected = self:getInput("Alignment").Value
	self:getOutput("Enum").Value = `Enum.TextXAlignment.{selected}`
	return ""
end

return TextXAlignmentNode
