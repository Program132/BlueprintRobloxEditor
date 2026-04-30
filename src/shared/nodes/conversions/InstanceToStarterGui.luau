local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToStarterGui = {}
InstanceToStarterGui.__index = InstanceToStarterGui
setmetatable(InstanceToStarterGui, Node)

local PROPERTIES = {
	"ProcessUserInput", "RtlTextSupport", "ScreenOrientation", 
	"ShowDevelopmentGui", "VirtualCursorMode"
}

function InstanceToStarterGui.new()
	local self = Node.new("Instance To StarterGui", NodeType.FUNCTION)
	setmetatable(self, InstanceToStarterGui)

	self:editTitle("Instance To StarterGui")
	self:editColor(Color3.fromRGB(120, 100, 180)) -- Conversion color

	self:addInput(IO.Input.new("Instance", "game:GetService('StarterGui')"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToStarterGui:toLuau()
	local instVar = self:getInput("Instance").Value or "game:GetService('StarterGui')"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToStarterGui
