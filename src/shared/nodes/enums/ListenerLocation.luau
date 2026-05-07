local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Locations = {
	"Default", "None", "Character", "Camera"
}

local ListenerLocationNode = {}
ListenerLocationNode.__index = ListenerLocationNode
setmetatable(ListenerLocationNode, Node)

function ListenerLocationNode.new()
	local self = Node.new("Enum ListenerLocation", NodeType.ENUM)
	setmetatable(self, ListenerLocationNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Location", "Default", false, Locations))
	self:addOutput(IO.Output.new("Enum", "Enum.ListenerLocation.Default"))
	
	return self
end

function ListenerLocationNode:toLuau()
	local selected = self:getInput("Location").Value
	self:getOutput("Enum").Value = `Enum.ListenerLocation.{selected}`
	return ""
end

return ListenerLocationNode
