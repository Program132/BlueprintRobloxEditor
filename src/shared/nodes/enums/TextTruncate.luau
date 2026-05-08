local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Options = { "None", "AtEnd", "SplitWord" }

local TextTruncateNode = {}
TextTruncateNode.__index = TextTruncateNode
setmetatable(TextTruncateNode, Node)

function TextTruncateNode.new()
	local self = Node.new("Enum TextTruncate", NodeType.ENUM)
	setmetatable(self, TextTruncateNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Truncate", "None", false, Options))
	self:addOutput(IO.Output.new("Enum", "Enum.TextTruncate.None"))
	
	return self
end

function TextTruncateNode:toLuau()
	local selected = self:getInput("Truncate").Value
	self:getOutput("Enum").Value = `Enum.TextTruncate.{selected}`
	return ""
end

return TextTruncateNode
