local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local CameraTypes = {
	"Fixed", "Attach", "Watch", "Track", "Follow", "Custom", "Scriptable", "Orbital"
}

local CameraTypeNode = {}
CameraTypeNode.__index = CameraTypeNode
setmetatable(CameraTypeNode, Node)

function CameraTypeNode.new()
	local self = Node.new("Enum CameraType", NodeType.ENUM)
	setmetatable(self, CameraTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40)) -- Yellow-ish for Enums
	
	self:addInput(IO.Input.new("Type", "Custom", false, CameraTypes))
	self:addOutput(IO.Output.new("Enum", "Enum.CameraType.Custom"))
	
	return self
end

function CameraTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.CameraType.{selected}`
	return ""
end

return CameraTypeNode
