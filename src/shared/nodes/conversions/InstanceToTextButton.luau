local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToTextButton = {}
InstanceToTextButton.__index = InstanceToTextButton
setmetatable(InstanceToTextButton, Node)

local PROPERTIES = {
	-- Text specific
	"ContentText", "Font", "FontFace", "FontSize", "LineHeight", "LocalizedText",
	"MaxVisibleGraphemes", "OpenTypeFeatures", "OpenTypeFeaturesError", "RichText",
	"Text", "TextBounds", "TextColor3", "TextDirection", "TextFits", "TextScaled",
	"TextSize", "TextStrokeColor3", "TextStrokeTransparency", "TextTransparency",
	"TextTruncate", "TextWrapped", "TextXAlignment", "TextYAlignment",
	
	-- Button specific
	"AutoButtonColor", "HoverHapticEffect", "Modal", "PressHapticEffect",
	"Selected", "Style",
	
	-- GuiObject
	"Active", "AnchorPoint", "AutomaticSize", "BackgroundColor3", "BackgroundTransparency",
	"BorderColor3", "BorderMode", "BorderSizePixel", "ClipsDescendants", "GuiState",
	"InputSink", "Interactable", "LayoutOrder", "NextSelectionDown", "NextSelectionLeft",
	"NextSelectionRight", "NextSelectionUp", "Position", "Rotation", "Selectable",
	"SelectionImageObject", "SelectionOrder", "Size", "SizeConstraint", "Visible", "ZIndex",
	
	-- Absolute & Localization
	"AbsolutePosition", "AbsoluteRotation", "AbsoluteSize", "AutoLocalize", "Localize",
	"RootLocalizationTable", "SelectionBehaviorDown", "SelectionBehaviorLeft",
	"SelectionBehaviorRight", "SelectionBehaviorUp", "SelectionGroup",
	
	-- Base
	"Archivable", "Capabilities", "Name", "Parent", "PredictionMode", "Sandboxed", "UniqueId"
}

function InstanceToTextButton.new()
	local self = Node.new("Instance to TextButton", NodeType.FUNCTION)
	setmetatable(self, InstanceToTextButton)
	self:editColor(Color3.fromRGB(150, 150, 255))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToTextButton:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		self:getOutput(prop).Value = `{instVar}.{prop}`
	end

	return ""
end

return InstanceToTextButton
