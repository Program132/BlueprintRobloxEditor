local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Types = {
	"MouseButton1", "MouseButton2", "MouseButton3", "MouseWheel", "MouseMovement",
	"Touch", "Keyboard", "Focus", "Accelerometer", "Gyro",
	"Gamepad1", "Gamepad2", "Gamepad3", "Gamepad4", "Gamepad5", "Gamepad6", "Gamepad7", "Gamepad8",
	"TextInput", "InputMethod", "None"
}

local UserInputTypeNode = {}
UserInputTypeNode.__index = UserInputTypeNode
setmetatable(UserInputTypeNode, Node)

function UserInputTypeNode.new()
	local self = Node.new("Enum UserInputType", NodeType.ENUM)
	setmetatable(self, UserInputTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40)) -- Yellow-ish for Enums
	
	self:addInput(IO.Input.new("Type", "Keyboard", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.UserInputType.Keyboard"))
	
	return self
end

function UserInputTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.UserInputType.{selected}`
	return ""
end

return UserInputTypeNode
