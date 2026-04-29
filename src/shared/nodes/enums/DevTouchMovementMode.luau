local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = {
	"UserChoice", "Thumbstick", "DPad", "Thumbpad", "ClickToMove", "Scriptable", "DynamicThumbstick"
}

local DevTouchMovementModeNode = {}
DevTouchMovementModeNode.__index = DevTouchMovementModeNode
setmetatable(DevTouchMovementModeNode, Node)

function DevTouchMovementModeNode.new()
	local self = Node.new("Enum DevTouchMovementMode", NodeType.ENUM)
	setmetatable(self, DevTouchMovementModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "UserChoice", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.DevTouchMovementMode.UserChoice"))
	
	return self
end

function DevTouchMovementModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.DevTouchMovementMode.{selected}`
	return ""
end

return DevTouchMovementModeNode
