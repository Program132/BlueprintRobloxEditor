local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local UserInputServiceProps = {}
UserInputServiceProps.__index = UserInputServiceProps
setmetatable(UserInputServiceProps, Node)

function UserInputServiceProps.new()
	local self = Node.new("Instance to UserInputService", NodeType.FUNCTION)
	setmetatable(self, UserInputServiceProps)
	self:editColor(Color3.fromRGB(0, 180, 200))
	
	self:addInput(IO.Input.new("Instance", "game:GetService('UserInputService')"))
	
	self:addOutput(IO.Output.new("AccelerometerEnabled", "false"))
	self:addOutput(IO.Output.new("GamepadEnabled", "false"))
	self:addOutput(IO.Output.new("GyroscopeEnabled", "false"))
	self:addOutput(IO.Output.new("KeyboardEnabled", "false"))
	self:addOutput(IO.Output.new("ModalEnabled", "false"))
	self:addOutput(IO.Output.new("MouseBehavior", "Enum.MouseBehavior.Default"))
	self:addOutput(IO.Output.new("MouseDeltaSensitivity", "1"))
	self:addOutput(IO.Output.new("MouseEnabled", "false"))
	self:addOutput(IO.Output.new("MouseIcon", "''"))
	self:addOutput(IO.Output.new("MouseIconContent", "''"))
	self:addOutput(IO.Output.new("MouseIconEnabled", "true"))
	self:addOutput(IO.Output.new("OnScreenKeyboardPosition", "Vector2.new()"))
	self:addOutput(IO.Output.new("OnScreenKeyboardSize", "Vector2.new()"))
	self:addOutput(IO.Output.new("OnScreenKeyboardVisible", "false"))
	self:addOutput(IO.Output.new("PreferredInput", "Enum.PreferredInput.Keyboard"))
	self:addOutput(IO.Output.new("TouchEnabled", "false"))
	self:addOutput(IO.Output.new("TouchScreenEnabled", "false"))
	
	return self
end

function UserInputServiceProps:toLuau()
	local uis = self:getInput("Instance").Value or "game:GetService('UserInputService')"
	
	self:getOutput("AccelerometerEnabled").Value = `{uis}.AccelerometerEnabled`
	self:getOutput("GamepadEnabled").Value = `{uis}.GamepadEnabled`
	self:getOutput("GyroscopeEnabled").Value = `{uis}.GyroscopeEnabled`
	self:getOutput("KeyboardEnabled").Value = `{uis}.KeyboardEnabled`
	self:getOutput("ModalEnabled").Value = `{uis}.ModalEnabled`
	self:getOutput("MouseBehavior").Value = `{uis}.MouseBehavior`
	self:getOutput("MouseDeltaSensitivity").Value = `{uis}.MouseDeltaSensitivity`
	self:getOutput("MouseEnabled").Value = `{uis}.MouseEnabled`
	self:getOutput("MouseIcon").Value = `{uis}.MouseIcon`
	self:getOutput("MouseIconContent").Value = `{uis}.MouseIconContent`
	self:getOutput("MouseIconEnabled").Value = `{uis}.MouseIconEnabled`
	self:getOutput("OnScreenKeyboardPosition").Value = `{uis}.OnScreenKeyboardPosition`
	self:getOutput("OnScreenKeyboardSize").Value = `{uis}.OnScreenKeyboardSize`
	self:getOutput("OnScreenKeyboardVisible").Value = `{uis}.OnScreenKeyboardVisible`
	self:getOutput("PreferredInput").Value = `{uis}.PreferredInput`
	self:getOutput("TouchEnabled").Value = `{uis}.TouchEnabled`
	self:getOutput("TouchScreenEnabled").Value = `{uis}.TouchScreenEnabled`
	
	return ""
end

return UserInputServiceProps
