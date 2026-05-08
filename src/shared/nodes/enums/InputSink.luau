local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Sinks = { "None", "Activate", "All" }

local InputSinkNode = {}
InputSinkNode.__index = InputSinkNode
setmetatable(InputSinkNode, Node)

function InputSinkNode.new()
	local self = Node.new("Enum InputSink", NodeType.ENUM)
	setmetatable(self, InputSinkNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Sink", "None", false, Sinks))
	self:addOutput(IO.Output.new("Enum", "Enum.InputSink.None"))
	
	return self
end

function InputSinkNode:toLuau()
	local selected = self:getInput("Sink").Value
	self:getOutput("Enum").Value = `Enum.InputSink.{selected}`
	return ""
end

return InputSinkNode
