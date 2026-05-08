local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Insets = { "None", "DeviceSafeInsets", "CoreUISafeInsets", "TopbarSafeInsets" }

local ScreenInsetsNode = {}
ScreenInsetsNode.__index = ScreenInsetsNode
setmetatable(ScreenInsetsNode, Node)

function ScreenInsetsNode.new()
	local self = Node.new("Enum ScreenInsets", NodeType.ENUM)
	setmetatable(self, ScreenInsetsNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Insets", "CoreUISafeInsets", false, Insets))
	self:addOutput(IO.Output.new("Enum", "Enum.ScreenInsets.CoreUISafeInsets"))
	
	return self
end

function ScreenInsetsNode:toLuau()
	local selected = self:getInput("Insets").Value
	self:getOutput("Enum").Value = `Enum.ScreenInsets.{selected}`
	return ""
end

return ScreenInsetsNode
