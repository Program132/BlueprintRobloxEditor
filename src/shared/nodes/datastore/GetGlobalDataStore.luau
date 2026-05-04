local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetGlobalDataStore = {}
GetGlobalDataStore.__index = GetGlobalDataStore
setmetatable(GetGlobalDataStore, Node)

function GetGlobalDataStore.new()
	local self = Node.new("DataStoreService GetGlobalDataStore", NodeType.FUNCTION)
	setmetatable(self, GetGlobalDataStore)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addOutput(IO.Output.new("DataStore", "nil"))
	
	return self
end

function GetGlobalDataStore:toLuau()
	self:getOutput("DataStore").Value = `game:GetService("DataStoreService"):GetGlobalDataStore()`
	return ""
end

return GetGlobalDataStore
