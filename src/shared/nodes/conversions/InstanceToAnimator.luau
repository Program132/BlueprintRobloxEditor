local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToAnimator = {}
InstanceToAnimator.__index = InstanceToAnimator
setmetatable(InstanceToAnimator, Node)

local PROPERTIES = {
	"EvaluationThrottled", "PreferLodEnabled", "RootMotion", "RootMotionWeight",
	"Archivable", "Capabilities", "Name", "Parent", "PredictionMode", "Sandboxed", "UniqueId"
}

function InstanceToAnimator.new()
	local self = Node.new("Instance to Animator", NodeType.FUNCTION)
	setmetatable(self, InstanceToAnimator)
	self:editColor(Color3.fromRGB(150, 100, 255))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToAnimator:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		self:getOutput(prop).Value = `{instVar}.{prop}`
	end

	return ""
end

return InstanceToAnimator
