local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToHumanoid = {}
InstanceToHumanoid.__index = InstanceToHumanoid
setmetatable(InstanceToHumanoid, Node)

local PROPERTIES = {
	-- Humanoid specific
	"AutoJumpEnabled", "AutomaticScalingEnabled", "AutoRotate", "BreakJointsOnDeath",
	"CameraOffset", "DisplayDistanceType", "DisplayName", "EvaluateStateMachine",
	"FloorMaterial", "Health", "HealthDisplayDistance", "HealthDisplayType",
	"HipHeight", "Jump", "JumpHeight", "JumpPower", "MaxHealth", "MaxSlopeAngle",
	"MoveDirection", "NameDisplayDistance", "NameOcclusion", "PlatformStand",
	"RequiresNeck", "RigType", "RootPart", "SeatPart", "Sit", "TargetPoint",
	"UseJumpPower", "WalkSpeed", "WalkToPart", "WalkToPoint",
	
	-- Base Instance properties
	"Archivable", "Capabilities", "Name", "Parent", "PredictionMode", "Sandboxed", "UniqueId"
}

function InstanceToHumanoid.new()
	local self = Node.new("Instance to Humanoid", NodeType.FUNCTION)
	setmetatable(self, InstanceToHumanoid)
	self:editColor(Color3.fromRGB(150, 150, 255))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToHumanoid:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		self:getOutput(prop).Value = `{instVar}.{prop}`
	end

	return ""
end

return InstanceToHumanoid
