local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = {
	"UserChoice", "KeyboardMouse", "ClickToMove", "Scriptable"
}

local DevComputerMovementModeNode = {}
DevComputerMovementModeNode.__index = DevComputerMovementModeNode
setmetatable(DevComputerMovementModeNode, Node)

function DevComputerMovementModeNode.new()
	local self = Node.new("Enum DevComputerMovementMode", NodeType.ENUM)
	setmetatable(self, DevComputerMovementModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "UserChoice", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.DevComputerMovementMode.UserChoice"))
	
	return self
end

function DevComputerMovementModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.DevComputerMovementMode.{selected}`
	return ""
end

return DevComputerMovementModeNode
