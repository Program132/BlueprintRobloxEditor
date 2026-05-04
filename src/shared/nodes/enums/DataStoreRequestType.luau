local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local DataStoreRequestTypes = {
	"GetAsync", "SetIncrementAsync", "UpdateAsync", "GetSortedAsync", 
	"SetIncrementSortedAsync", "OnUpdate", "ListAsync", "GetVersionAsync", 
	"RemoveVersionAsync", "StandardRead", "StandardWrite", "StandardList", 
	"StandardRemove", "OrderedRead", "OrderedWrite", "OrderedList", "OrderedRemove"
}

local DataStoreRequestTypeNode = {}
DataStoreRequestTypeNode.__index = DataStoreRequestTypeNode
setmetatable(DataStoreRequestTypeNode, Node)

function DataStoreRequestTypeNode.new()
	local self = Node.new("Enum DataStoreRequestType", NodeType.ENUM)
	setmetatable(self, DataStoreRequestTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "GetAsync", false, DataStoreRequestTypes))
	self:addOutput(IO.Output.new("Enum", "Enum.DataStoreRequestType.GetAsync"))
	
	return self
end

function DataStoreRequestTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.DataStoreRequestType.{selected}`
	return ""
end

return DataStoreRequestTypeNode
