local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Options = { "None", "FullscreenExtension" }

local SafeAreaCompatibilityNode = {}
SafeAreaCompatibilityNode.__index = SafeAreaCompatibilityNode
setmetatable(SafeAreaCompatibilityNode, Node)

function SafeAreaCompatibilityNode.new()
	local self = Node.new("Enum SafeAreaCompatibility", NodeType.ENUM)
	setmetatable(self, SafeAreaCompatibilityNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Compatibility", "FullscreenExtension", false, Options))
	self:addOutput(IO.Output.new("Enum", "Enum.SafeAreaCompatibility.FullscreenExtension"))
	
	return self
end

function SafeAreaCompatibilityNode:toLuau()
	local selected = self:getInput("Compatibility").Value
	self:getOutput("Enum").Value = `Enum.SafeAreaCompatibility.{selected}`
	return ""
end

return SafeAreaCompatibilityNode
