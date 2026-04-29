local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = {
	"Zoom", "Invisicam"
}

local DevCameraOcclusionModeNode = {}
DevCameraOcclusionModeNode.__index = DevCameraOcclusionModeNode
setmetatable(DevCameraOcclusionModeNode, Node)

function DevCameraOcclusionModeNode.new()
	local self = Node.new("Enum DevCameraOcclusionMode", NodeType.ENUM)
	setmetatable(self, DevCameraOcclusionModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "Zoom", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.DevCameraOcclusionMode.Zoom"))
	
	return self
end

function DevCameraOcclusionModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.DevCameraOcclusionMode.{selected}`
	return ""
end

return DevCameraOcclusionModeNode
