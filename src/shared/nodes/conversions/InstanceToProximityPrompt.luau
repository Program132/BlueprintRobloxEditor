local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToProximityPrompt = {}
InstanceToProximityPrompt.__index = InstanceToProximityPrompt
setmetatable(InstanceToProximityPrompt, Node)

function InstanceToProximityPrompt.new()
	local self = Node.new("Instance to ProximityPrompt", NodeType.FUNCTION)
	setmetatable(self, InstanceToProximityPrompt)
	self:editColor(Color3.fromRGB(255, 100, 50))
	
	self:addInput(IO.Input.new("Instance", "nil"))
	
	self:addOutput(IO.Output.new("ActionText", "''"))
	self:addOutput(IO.Output.new("AutoLocalize", "true"))
	self:addOutput(IO.Output.new("ClickablePrompt", "true"))
	self:addOutput(IO.Output.new("Enabled", "true"))
	self:addOutput(IO.Output.new("Exclusivity", "Enum.ProximityPromptExclusivity.OnePerButton"))
	self:addOutput(IO.Output.new("GamepadKeyCode", "Enum.KeyCode.ButtonX"))
	self:addOutput(IO.Output.new("HoldDuration", "0"))
	self:addOutput(IO.Output.new("KeyboardKeyCode", "Enum.KeyCode.E"))
	self:addOutput(IO.Output.new("MaxActivationDistance", "10"))
	self:addOutput(IO.Output.new("MaxIndicatorDistance", "20"))
	self:addOutput(IO.Output.new("ObjectText", "''"))
	self:addOutput(IO.Output.new("RequiresLineOfSight", "true"))
	self:addOutput(IO.Output.new("Style", "Enum.ProximityPromptStyle.Default"))
	self:addOutput(IO.Output.new("UIOffset", "Vector2.new()"))
	
	-- Base Properties
	self:addOutput(IO.Output.new("Archivable", "true"))
	self:addOutput(IO.Output.new("Capabilities", "nil"))
	self:addOutput(IO.Output.new("Name", "'ProximityPrompt'"))
	self:addOutput(IO.Output.new("Parent", "nil"))
	self:addOutput(IO.Output.new("PredictionMode", "Enum.PredictionMode.Automatic"))
	self:addOutput(IO.Output.new("Sandboxed", "false"))
	self:addOutput(IO.Output.new("UniqueId", "''"))
	
	return self
end

function InstanceToProximityPrompt:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	
	self:getOutput("ActionText").Value = `{inst}.ActionText`
	self:getOutput("AutoLocalize").Value = `{inst}.AutoLocalize`
	self:getOutput("ClickablePrompt").Value = `{inst}.ClickablePrompt`
	self:getOutput("Enabled").Value = `{inst}.Enabled`
	self:getOutput("Exclusivity").Value = `{inst}.Exclusivity`
	self:getOutput("GamepadKeyCode").Value = `{inst}.GamepadKeyCode`
	self:getOutput("HoldDuration").Value = `{inst}.HoldDuration`
	self:getOutput("KeyboardKeyCode").Value = `{inst}.KeyboardKeyCode`
	self:getOutput("MaxActivationDistance").Value = `{inst}.MaxActivationDistance`
	self:getOutput("MaxIndicatorDistance").Value = `{inst}.MaxIndicatorDistance`
	self:getOutput("ObjectText").Value = `{inst}.ObjectText`
	self:getOutput("RequiresLineOfSight").Value = `{inst}.RequiresLineOfSight`
	self:getOutput("Style").Value = `{inst}.Style`
	self:getOutput("UIOffset").Value = `{inst}.UIOffset`
	
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

return InstanceToProximityPrompt
