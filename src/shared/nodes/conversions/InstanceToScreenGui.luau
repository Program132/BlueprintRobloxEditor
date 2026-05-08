local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToScreenGui = {}
InstanceToScreenGui.__index = InstanceToScreenGui
setmetatable(InstanceToScreenGui, Node)

local PROPERTIES = {
	-- ScreenGui specific
	"ClipToDeviceSafeArea", "DisplayOrder", "IgnoreGuiInset",
	"SafeAreaCompatibility", "ScreenInsets", "Enabled", "ResetOnSpawn",
	"TabKeyboardNavigation", "ZIndexBehavior",
	
	-- Absolute & Localization
	"AbsolutePosition", "AbsoluteRotation", "AbsoluteSize", "AutoLocalize", "Localize",
	"RootLocalizationTable", "SelectionBehaviorDown", "SelectionBehaviorLeft",
	"SelectionBehaviorRight", "SelectionBehaviorUp", "SelectionGroup",
	
	-- Base
	"Archivable", "Capabilities", "Name", "Parent", "PredictionMode", "Sandboxed", "UniqueId"
}

function InstanceToScreenGui.new()
	local self = Node.new("Instance to ScreenGui", NodeType.FUNCTION)
	setmetatable(self, InstanceToScreenGui)
	self:editColor(Color3.fromRGB(150, 150, 255))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToScreenGui:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		self:getOutput(prop).Value = `{instVar}.{prop}`
	end

	return ""
end

return InstanceToScreenGui
