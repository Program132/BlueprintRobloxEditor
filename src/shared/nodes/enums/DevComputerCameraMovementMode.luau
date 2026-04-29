local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = {
	"UserChoice", "Classic", "Follow", "Orbital", "CameraToggle"
}

local DevComputerCameraMovementModeNode = {}
DevComputerCameraMovementModeNode.__index = DevComputerCameraMovementModeNode
setmetatable(DevComputerCameraMovementModeNode, Node)

function DevComputerCameraMovementModeNode.new()
	local self = Node.new("Enum DevComputerCameraMovementMode", NodeType.ENUM)
	setmetatable(self, DevComputerCameraMovementModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "UserChoice", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.DevComputerCameraMovementMode.UserChoice"))
	
	return self
end

function DevComputerCameraMovementModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.DevComputerCameraMovementMode.{selected}`
	return ""
end

return DevComputerCameraMovementModeNode
