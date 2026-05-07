local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local InstanceToSoundServiceNode = {}
InstanceToSoundServiceNode.__index = InstanceToSoundServiceNode
setmetatable(InstanceToSoundServiceNode, Node)

function InstanceToSoundServiceNode.new()
	local self = Node.new("Instance to SoundService", NodeType.FUNCTION)
	setmetatable(self, InstanceToSoundServiceNode)
	self:editColor(Color3.fromRGB(255, 100, 200))
	
	self:addInput(IO.Input.new("Instance", "nil"))
	
	-- Custom properties
	self:addOutput(IO.Output.new("AcousticSimulationEnabled", "false"))
	self:addOutput(IO.Output.new("AmbientReverb", "Enum.ReverbType.NoReverb"))
	self:addOutput(IO.Output.new("CharacterSoundsUseNewApi", "Enum.RolloutState.Default"))
	self:addOutput(IO.Output.new("DefaultListenerLocation", "Enum.ListenerLocation.Default"))
	self:addOutput(IO.Output.new("DistanceFactor", "1"))
	self:addOutput(IO.Output.new("DopplerScale", "1"))
	self:addOutput(IO.Output.new("RespectFilteringEnabled", "true"))
	self:addOutput(IO.Output.new("RolloffScale", "1"))
	self:addOutput(IO.Output.new("VolumetricAudio", "Enum.VolumetricAudio.Disabled"))
	
	-- Base instance properties
	self:addOutput(IO.Output.new("Archivable", "true"))
	self:addOutput(IO.Output.new("Capabilities", "nil"))
	self:addOutput(IO.Output.new("Name", "''"))
	self:addOutput(IO.Output.new("Parent", "nil"))
	self:addOutput(IO.Output.new("PredictionMode", "Enum.PredictionMode.Default"))
	self:addOutput(IO.Output.new("Sandboxed", "false"))
	self:addOutput(IO.Output.new("UniqueId", "''"))
	
	return self
end

function InstanceToSoundServiceNode:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	
	self:getOutput("AcousticSimulationEnabled").Value = `{inst}.AcousticSimulationEnabled`
	self:getOutput("AmbientReverb").Value = `{inst}.AmbientReverb`
	self:getOutput("CharacterSoundsUseNewApi").Value = `{inst}.CharacterSoundsUseNewApi`
	self:getOutput("DefaultListenerLocation").Value = `{inst}.DefaultListenerLocation`
	self:getOutput("DistanceFactor").Value = `{inst}.DistanceFactor`
	self:getOutput("DopplerScale").Value = `{inst}.DopplerScale`
	self:getOutput("RespectFilteringEnabled").Value = `{inst}.RespectFilteringEnabled`
	self:getOutput("RolloffScale").Value = `{inst}.RolloffScale`
	self:getOutput("VolumetricAudio").Value = `{inst}.VolumetricAudio`
	
	self:getOutput("Archivable").Value = `{inst}.Archivable`
	self:getOutput("Capabilities").Value = `{inst}.Capabilities`
	self:getOutput("Name").Value = `{inst}.Name`
	self:getOutput("Parent").Value = `{inst}.Parent`
	self:getOutput("PredictionMode").Value = `{inst}.PredictionMode`
	self:getOutput("Sandboxed").Value = `{inst}.Sandboxed`
	self:getOutput("UniqueId").Value = `{inst}.UniqueId`
	
	return ""
end

return InstanceToSoundServiceNode
