local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToTextBox = {}
InstanceToTextBox.__index = InstanceToTextBox
setmetatable(InstanceToTextBox, Node)

local PROPERTIES = {
	-- TextBox specific
	"ClearTextOnFocus", "ContentText", "CursorPosition", "Font", "FontFace",
	"FontSize", "LineHeight", "MaxVisibleGraphemes", "MultiLine", "OpenTypeFeatures",
	"OpenTypeFeaturesError", "PlaceholderColor3", "PlaceholderText", "RichText",
	"SelectionStart", "ShowNativeInput", "Text", "TextBounds", "TextColor3",
	"TextDirection", "TextEditable", "TextFits", "TextScaled", "TextSize",
	"TextStrokeColor3", "TextStrokeTransparency", "TextTransparency", "TextTruncate",
	"TextWrapped", "TextXAlignment", "TextYAlignment",
	
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

function InstanceToTextBox.new()
	local self = Node.new("Instance to TextBox", NodeType.FUNCTION)
	setmetatable(self, InstanceToTextBox)
	self:editColor(Color3.fromRGB(150, 150, 255))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToTextBox:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		self:getOutput(prop).Value = `{instVar}.{prop}`
	end

	return ""
end

return InstanceToTextBox
