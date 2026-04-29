local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = {
	"UserChoice", "Classic", "Follow", "Orbital"
}

local DevTouchCameraMovementModeNode = {}
DevTouchCameraMovementModeNode.__index = DevTouchCameraMovementModeNode
setmetatable(DevTouchCameraMovementModeNode, Node)

function DevTouchCameraMovementModeNode.new()
	local self = Node.new("Enum DevTouchCameraMovementMode", NodeType.ENUM)
	setmetatable(self, DevTouchCameraMovementModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "UserChoice", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.DevTouchCameraMovementMode.UserChoice"))
	
	return self
end

function DevTouchCameraMovementModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.DevTouchCameraMovementMode.{selected}`
	return ""
end

return DevTouchCameraMovementModeNode
