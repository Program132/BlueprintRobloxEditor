local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Types = {
	"Ball", "Block", "Cylinder", "Wedge", "CornerWedge"
}

local PartTypeNode = {}
PartTypeNode.__index = PartTypeNode
setmetatable(PartTypeNode, Node)

function PartTypeNode.new()
	local self = Node.new("Enum PartType", NodeType.ENUM)
	setmetatable(self, PartTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40)) -- Yellow-ish for Enums
	
	self:addInput(IO.Input.new("Type", "Block", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.PartType.Block"))
	
	return self
end

function PartTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.PartType.{selected}`
	return ""
end

return PartTypeNode
