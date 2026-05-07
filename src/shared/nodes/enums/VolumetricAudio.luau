local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Options = {
	"Disabled", "Automatic", "Enabled"
}

local VolumetricAudioNode = {}
VolumetricAudioNode.__index = VolumetricAudioNode
setmetatable(VolumetricAudioNode, Node)

function VolumetricAudioNode.new()
	local self = Node.new("Enum VolumetricAudio", NodeType.ENUM)
	setmetatable(self, VolumetricAudioNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Setting", "Disabled", false, Options))
	self:addOutput(IO.Output.new("Enum", "Enum.VolumetricAudio.Disabled"))
	
	return self
end

function VolumetricAudioNode:toLuau()
	local selected = self:getInput("Setting").Value
	self:getOutput("Enum").Value = `Enum.VolumetricAudio.{selected}`
	return ""
end

return VolumetricAudioNode
