local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToSound = {}
InstanceToSound.__index = InstanceToSound
setmetatable(InstanceToSound, Node)

local PROPERTIES = {
	"AcousticSimulationEnabled", "AudioContent", "IsLoaded", "IsPaused", "IsPlaying",
	"Looped", "LoopRegion", "PlaybackLoudness", "PlaybackRegion", "PlaybackRegionsEnabled",
	"PlaybackSpeed", "Playing", "PlayOnRemove", "RollOffMaxDistance", "RollOffMinDistance",
	"RollOffMode", "SoundGroup", "SoundId", "TimeLength", "TimePosition", "Volume"
}

function InstanceToSound.new()
	local self = Node.new("Instance To Sound", NodeType.FUNCTION)
	setmetatable(self, InstanceToSound)

	self:editTitle("Instance To Sound")
	self:editColor(Color3.fromRGB(120, 100, 180))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToSound:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToSound
