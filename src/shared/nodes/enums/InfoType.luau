local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InfoTypes = {
	"Asset", "Product", "GamePass", "Subscription", "Bundle"
}

local InfoTypeNode = {}
InfoTypeNode.__index = InfoTypeNode
setmetatable(InfoTypeNode, Node)

function InfoTypeNode.new()
	local self = Node.new("Enum InfoType", NodeType.ENUM)
	setmetatable(self, InfoTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Asset", false, InfoTypes))
	self:addOutput(IO.Output.new("Enum", "Enum.InfoType.Asset"))
	
	return self
end

function InfoTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.InfoType.{selected}`
	return ""
end

return InfoTypeNode
