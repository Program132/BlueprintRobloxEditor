local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ListKeysAsync = {}
ListKeysAsync.__index = ListKeysAsync
setmetatable(ListKeysAsync, Node)

function ListKeysAsync.new()
	local self = Node.new("DataStore ListKeysAsync", NodeType.METHOD)
	setmetatable(self, ListKeysAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Prefix", '""'))
	self:addInput(IO.Input.new("PageSize", "50"))
	self:addInput(IO.Input.new("Cursor", '""'))
	self:addInput(IO.Input.new("ExcludeDeleted", "false"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Pages", "nil"))
	
	return self
end

function ListKeysAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local prefix = self:getInput("Prefix").Value or '""'
	local pageSize = self:getInput("PageSize").Value or "50"
	local cursor = self:getInput("Cursor").Value or '""'
	local exclude = self:getInput("ExcludeDeleted").Value or "false"
	local pagesVar = `pages_{self.Id:gsub("-", "_")}`
	
	self:getOutput("Pages").Value = pagesVar
	
	return `local {pagesVar} = {ds}:ListKeysAsync({prefix}, {pageSize}, {cursor}, {exclude})\n`
end

return ListKeysAsync
