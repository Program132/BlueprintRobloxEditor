local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Frequencies = {
	"Hz60", "Hz30", "Hz15", "Hz10", "Hz5", "Hz1"
}

local StepFrequencyNode = {}
StepFrequencyNode.__index = StepFrequencyNode
setmetatable(StepFrequencyNode, Node)

function StepFrequencyNode.new()
	local self = Node.new("Enum StepFrequency", NodeType.ENUM)
	setmetatable(self, StepFrequencyNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Frequency", "Hz60", false, Frequencies))
	self:addOutput(IO.Output.new("Enum", "Enum.StepFrequency.Hz60"))
	
	return self
end

function StepFrequencyNode:toLuau()
	local selected = self:getInput("Frequency").Value
	self:getOutput("Enum").Value = `Enum.StepFrequency.{selected}`
	return ""
end

return StepFrequencyNode
