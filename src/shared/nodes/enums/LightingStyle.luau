local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Styles = {
	"Realistic", "Soft"
}

local LightingStyleNode = {}
LightingStyleNode.__index = LightingStyleNode
setmetatable(LightingStyleNode, Node)

function LightingStyleNode.new()
	local self = Node.new("Enum LightingStyle", NodeType.ENUM)
	setmetatable(self, LightingStyleNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Style", "Realistic", false, Styles))
	self:addOutput(IO.Output.new("Enum", "Enum.LightingStyle.Realistic"))
	
	return self
end

function LightingStyleNode:toLuau()
	local selected = self:getInput("Style").Value
	self:getOutput("Enum").Value = `Enum.LightingStyle.{selected}`
	return ""
end

return LightingStyleNode
