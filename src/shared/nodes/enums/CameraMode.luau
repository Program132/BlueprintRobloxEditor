local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local CameraModes = {
	"Classic", "LockFirstPerson"
}

local CameraModeNode = {}
CameraModeNode.__index = CameraModeNode
setmetatable(CameraModeNode, Node)

function CameraModeNode.new()
	local self = Node.new("Enum CameraMode", NodeType.ENUM)
	setmetatable(self, CameraModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "Classic", false, CameraModes))
	self:addOutput(IO.Output.new("Enum", "Enum.CameraMode.Classic"))
	
	return self
end

function CameraModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.CameraMode.{selected}`
	return ""
end

return CameraModeNode
