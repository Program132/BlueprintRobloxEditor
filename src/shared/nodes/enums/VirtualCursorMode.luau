local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local VirtualCursorModes = {
	"Default", "Disabled", "Enabled"
}

local VirtualCursorModeNode = {}
VirtualCursorModeNode.__index = VirtualCursorModeNode
setmetatable(VirtualCursorModeNode, Node)

function VirtualCursorModeNode.new()
	local self = Node.new("Enum VirtualCursorMode", NodeType.ENUM)
	setmetatable(self, VirtualCursorModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Default", false, VirtualCursorModes))
	self:addOutput(IO.Output.new("Enum", "Enum.VirtualCursorMode.Default"))
	
	return self
end

function VirtualCursorModeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.VirtualCursorMode.{selected}`
	return ""
end

return VirtualCursorModeNode
