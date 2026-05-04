local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ListDataStoresAsync = {}
ListDataStoresAsync.__index = ListDataStoresAsync
setmetatable(ListDataStoresAsync, Node)

function ListDataStoresAsync.new()
	local self = Node.new("DataStoreService ListDataStoresAsync", NodeType.METHOD)
	setmetatable(self, ListDataStoresAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Prefix", '""'))
	self:addInput(IO.Input.new("PageSize", "50"))
	self:addInput(IO.Input.new("Cursor", '""'))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Pages", "nil"))
	
	return self
end

function ListDataStoresAsync:toLuau()
	local prefix = self:getInput("Prefix").Value or '""'
	local pageSize = self:getInput("PageSize").Value or "50"
	local cursor = self:getInput("Cursor").Value or '""'
	local pagesVar = `pages_{self.Id:gsub("-", "_")}`
	
	self:getOutput("Pages").Value = pagesVar
	
	return `local {pagesVar} = game:GetService("DataStoreService"):ListDataStoresAsync({prefix}, {pageSize}, {cursor})\n`
end

return ListDataStoresAsync
