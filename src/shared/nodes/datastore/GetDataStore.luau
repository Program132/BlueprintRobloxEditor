local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetDataStore = {}
GetDataStore.__index = GetDataStore
setmetatable(GetDataStore, Node)

function GetDataStore.new()
	local self = Node.new("DataStoreService GetDataStore", NodeType.FUNCTION)
	setmetatable(self, GetDataStore)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Name", '""'))
	self:addInput(IO.Input.new("Scope", '""'))
	self:addInput(IO.Input.new("Options", "nil"))
	
	self:addOutput(IO.Output.new("DataStore", "nil"))
	
	return self
end

function GetDataStore:toLuau()
	local name = self:getInput("Name").Value or '""'
	local scope = self:getInput("Scope").Value or '""'
	local options = self:getInput("Options").Value or "nil"
	
	self:getOutput("DataStore").Value = `game:GetService("DataStoreService"):GetDataStore({name}, {scope}, {options})`
	return ""
end

return GetDataStore
