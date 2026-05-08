local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = { "Outline", "Middle", "Inset" }

local BorderModeNode = {}
BorderModeNode.__index = BorderModeNode
setmetatable(BorderModeNode, Node)

function BorderModeNode.new()
	local self = Node.new("Enum BorderMode", NodeType.ENUM)
	setmetatable(self, BorderModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "Outline", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.BorderMode.Outline"))
	
	return self
end

function BorderModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.BorderMode.{selected}`
	return ""
end

return BorderModeNode
