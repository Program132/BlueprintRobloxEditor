local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = {
	"Automatic", "On", "Off"
}

local PredictionModeNode = {}
PredictionModeNode.__index = PredictionModeNode
setmetatable(PredictionModeNode, Node)

function PredictionModeNode.new()
	local self = Node.new("Enum PredictionMode", NodeType.ENUM)
	setmetatable(self, PredictionModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "Automatic", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.PredictionMode.Automatic"))
	
	return self
end

function PredictionModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.PredictionMode.{selected}`
	return ""
end

return PredictionModeNode
