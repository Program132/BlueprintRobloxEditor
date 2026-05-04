local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetOrderedDataStore = {}
GetOrderedDataStore.__index = GetOrderedDataStore
setmetatable(GetOrderedDataStore, Node)

function GetOrderedDataStore.new()
	local self = Node.new("DataStoreService GetOrderedDataStore", NodeType.FUNCTION)
	setmetatable(self, GetOrderedDataStore)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Name", '""'))
	self:addInput(IO.Input.new("Scope", '""'))
	
	self:addOutput(IO.Output.new("OrderedDataStore", "nil"))
	
	return self
end

function GetOrderedDataStore:toLuau()
	local name = self:getInput("Name").Value or '""'
	local scope = self:getInput("Scope").Value or '""'
	
	self:getOutput("OrderedDataStore").Value = `game:GetService("DataStoreService"):GetOrderedDataStore({name}, {scope})`
	return ""
end

return GetOrderedDataStore
