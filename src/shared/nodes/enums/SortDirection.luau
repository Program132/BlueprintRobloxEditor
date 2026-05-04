local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SortDirections = {
	"Ascending", "Descending"
}

local SortDirectionNode = {}
SortDirectionNode.__index = SortDirectionNode
setmetatable(SortDirectionNode, Node)

function SortDirectionNode.new()
	local self = Node.new("Enum SortDirection", NodeType.ENUM)
	setmetatable(self, SortDirectionNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Ascending", false, SortDirections))
	self:addOutput(IO.Output.new("Enum", "Enum.SortDirection.Ascending"))
	
	return self
end

function SortDirectionNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.SortDirection.{selected}`
	return ""
end

return SortDirectionNode
