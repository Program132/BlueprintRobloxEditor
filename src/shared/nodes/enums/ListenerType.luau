local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Types = {
	"Camera", "CFrame", "ObjectPosition", "ObjectCFrame"
}

local ListenerTypeNode = {}
ListenerTypeNode.__index = ListenerTypeNode
setmetatable(ListenerTypeNode, Node)

function ListenerTypeNode.new()
	local self = Node.new("Enum ListenerType", NodeType.ENUM)
	setmetatable(self, ListenerTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Camera", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.ListenerType.Camera"))
	
	return self
end

function ListenerTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.ListenerType.{selected}`
	return ""
end

return ListenerTypeNode
