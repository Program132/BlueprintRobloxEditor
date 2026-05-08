local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToImageButton = {}
InstanceToImageButton.__index = InstanceToImageButton
setmetatable(InstanceToImageButton, Node)

local PROPERTIES = {
	-- Image Button specific
	"HoverImage", "HoverImageContent", "Image", "ImageColor3", "ImageContent",
	"ImageRectOffset", "ImageRectSize", "ImageTransparency", "IsLoaded",
	"PressedImage", "PressedImageContent", "ResampleMode", "ScaleType",
	"SliceCenter", "SliceScale", "TileSize",
	
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

function InstanceToImageButton.new()
	local self = Node.new("Instance to ImageButton", NodeType.FUNCTION)
	setmetatable(self, InstanceToImageButton)
	self:editColor(Color3.fromRGB(150, 150, 255))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToImageButton:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		self:getOutput(prop).Value = `{instVar}.{prop}`
	end

	return ""
end

return InstanceToImageButton
