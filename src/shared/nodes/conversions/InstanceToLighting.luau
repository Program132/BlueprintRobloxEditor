local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToLighting = {}
InstanceToLighting.__index = InstanceToLighting
setmetatable(InstanceToLighting, Node)

function InstanceToLighting.new()
	local self = Node.new("Instance to Lighting", NodeType.FUNCTION)
	setmetatable(self, InstanceToLighting)
	self:editColor(Color3.fromRGB(255, 200, 50))
	
	self:addInput(IO.Input.new("Instance", "game:GetService('Lighting')"))
	
	self:addOutput(IO.Output.new("Ambient", "Color3.new()"))
	self:addOutput(IO.Output.new("Brightness", "1"))
	self:addOutput(IO.Output.new("ClockTime", "12"))
	self:addOutput(IO.Output.new("ColorShift_Bottom", "Color3.new()"))
	self:addOutput(IO.Output.new("ColorShift_Top", "Color3.new()"))
	self:addOutput(IO.Output.new("EnvironmentDiffuseScale", "0"))
	self:addOutput(IO.Output.new("EnvironmentSpecularScale", "0"))
	self:addOutput(IO.Output.new("ExposureCompensation", "0"))
	self:addOutput(IO.Output.new("ExtendLightRangeTo120", "Enum.RolloutState.Default"))
	self:addOutput(IO.Output.new("FogColor", "Color3.new()"))
	self:addOutput(IO.Output.new("FogEnd", "100000"))
	self:addOutput(IO.Output.new("FogStart", "0"))
	self:addOutput(IO.Output.new("GeographicLatitude", "23.5"))
	self:addOutput(IO.Output.new("GlobalShadows", "true"))
	self:addOutput(IO.Output.new("LightingStyle", "Enum.LightingStyle.Realistic"))
	self:addOutput(IO.Output.new("OutdoorAmbient", "Color3.new()"))
	self:addOutput(IO.Output.new("Outlines", "false"))
	self:addOutput(IO.Output.new("PrioritizeLightingQuality", "true"))
	self:addOutput(IO.Output.new("ShadowColor", "Color3.new()"))
	self:addOutput(IO.Output.new("ShadowSoftness", "0.5"))
	self:addOutput(IO.Output.new("Technology", "Enum.Technology.Future"))
	self:addOutput(IO.Output.new("TimeOfDay", "'12:00:00'"))
	
	-- Base Properties
	self:addOutput(IO.Output.new("Archivable", "true"))
	self:addOutput(IO.Output.new("Capabilities", "nil"))
	self:addOutput(IO.Output.new("Name", "'Lighting'"))
	self:addOutput(IO.Output.new("Parent", "nil"))
	self:addOutput(IO.Output.new("PredictionMode", "Enum.PredictionMode.Automatic"))
	self:addOutput(IO.Output.new("Sandboxed", "false"))
	self:addOutput(IO.Output.new("UniqueId", "''"))
	
	return self
end

function InstanceToLighting:toLuau()
	local inst = self:getInput("Instance").Value or "game:GetService('Lighting')"
	
	self:getOutput("Ambient").Value = `{inst}.Ambient`
	self:getOutput("Brightness").Value = `{inst}.Brightness`
	self:getOutput("ClockTime").Value = `{inst}.ClockTime`
	self:getOutput("ColorShift_Bottom").Value = `{inst}.ColorShift_Bottom`
	self:getOutput("ColorShift_Top").Value = `{inst}.ColorShift_Top`
	self:getOutput("EnvironmentDiffuseScale").Value = `{inst}.EnvironmentDiffuseScale`
	self:getOutput("EnvironmentSpecularScale").Value = `{inst}.EnvironmentSpecularScale`
	self:getOutput("ExposureCompensation").Value = `{inst}.ExposureCompensation`
	self:getOutput("ExtendLightRangeTo120").Value = `{inst}.ExtendLightRangeTo120`
	self:getOutput("FogColor").Value = `{inst}.FogColor`
	self:getOutput("FogEnd").Value = `{inst}.FogEnd`
	self:getOutput("FogStart").Value = `{inst}.FogStart`
	self:getOutput("GeographicLatitude").Value = `{inst}.GeographicLatitude`
	self:getOutput("GlobalShadows").Value = `{inst}.GlobalShadows`
	self:getOutput("LightingStyle").Value = `{inst}.LightingStyle`
	self:getOutput("OutdoorAmbient").Value = `{inst}.OutdoorAmbient`
	self:getOutput("Outlines").Value = `{inst}.Outlines`
	self:getOutput("PrioritizeLightingQuality").Value = `{inst}.PrioritizeLightingQuality`
	self:getOutput("ShadowColor").Value = `{inst}.ShadowColor`
	self:getOutput("ShadowSoftness").Value = `{inst}.ShadowSoftness`
	self:getOutput("Technology").Value = `{inst}.Technology`
	self:getOutput("TimeOfDay").Value = `{inst}.TimeOfDay`
	
	-- Base Properties
	self:getOutput("Archivable").Value = `{inst}.Archivable`
	self:getOutput("Capabilities").Value = `{inst}.Capabilities`
	self:getOutput("Name").Value = `{inst}.Name`
	self:getOutput("Parent").Value = `{inst}.Parent`
	self:getOutput("PredictionMode").Value = `{inst}.PredictionMode`
	self:getOutput("Sandboxed").Value = `{inst}.Sandboxed`
	self:getOutput("UniqueId").Value = `{inst}.UniqueId`
	
	return ""
end

return InstanceToLighting
