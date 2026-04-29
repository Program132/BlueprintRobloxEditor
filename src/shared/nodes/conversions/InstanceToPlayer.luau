local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToPlayer = {}
InstanceToPlayer.__index = InstanceToPlayer
setmetatable(InstanceToPlayer, Node)

local PROPERTIES = {
	"AccountAge", "Archivable", "AutoJumpEnabled", "Backpack", "CameraMaxZoomDistance", "CameraMinZoomDistance",
	"CameraMode", "CanLoadCharacterAppearance", "Capabilities", "Character", "CharacterAppearanceId",
	"DevCameraOcclusionMode", "DevComputerCameraMode", "DevComputerMovementMode",
	"DevEnableMouseLock", "DevTouchCameraMode", "DevTouchMovementMode", "DisplayName",
	"FollowUserId", "GameplayPaused", "HasRobloxSubscription", "HasVerifiedBadge",
	"HealthDisplayDistance", "InputLatency", "LocaleId", "Name", "NameDisplayDistance",
	"Neutral", "Parent", "PartyId", "PredictionMode", "ReplicationFocus", "RespawnLocation",
	"Sandboxed", "StepIdOffset", "Team", "TeamColor", "ThirdPartyTextChatRestrictionStatus",
	"UniqueId", "UserId"
}

function InstanceToPlayer.new()
	local self = Node.new("Instance To Player", NodeType.FUNCTION)
	setmetatable(self, InstanceToPlayer)

	self:editTitle("Instance To Player")
	self:editColor(Color3.fromRGB(120, 100, 180))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToPlayer:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToPlayer
