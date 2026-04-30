local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local CurrencyTypes = {
	"Default", "Robux", "Tix"
}

local CurrencyTypeNode = {}
CurrencyTypeNode.__index = CurrencyTypeNode
setmetatable(CurrencyTypeNode, Node)

function CurrencyTypeNode.new()
	local self = Node.new("Enum CurrencyType", NodeType.ENUM)
	setmetatable(self, CurrencyTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Default", false, CurrencyTypes))
	self:addOutput(IO.Output.new("Enum", "Enum.CurrencyType.Default"))
	
	return self
end

function CurrencyTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.CurrencyType.{selected}`
	return ""
end

return CurrencyTypeNode
