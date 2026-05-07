local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Types = {
	"Keyboard", "Gamepad", "Touch"
}

local ProximityPromptInputTypeNode = {}
ProximityPromptInputTypeNode.__index = ProximityPromptInputTypeNode
setmetatable(ProximityPromptInputTypeNode, Node)

function ProximityPromptInputTypeNode.new()
	local self = Node.new("Enum ProximityPromptInputType", NodeType.ENUM)
	setmetatable(self, ProximityPromptInputTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Keyboard", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.ProximityPromptInputType.Keyboard"))
	
	return self
end

function ProximityPromptInputTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.ProximityPromptInputType.{selected}`
	return ""
end

return ProximityPromptInputTypeNode
