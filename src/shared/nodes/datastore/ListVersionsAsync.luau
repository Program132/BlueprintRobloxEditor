local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ListVersionsAsync = {}
ListVersionsAsync.__index = ListVersionsAsync
setmetatable(ListVersionsAsync, Node)

function ListVersionsAsync.new()
	local self = Node.new("DataStore ListVersionsAsync", NodeType.METHOD)
	setmetatable(self, ListVersionsAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	self:addInput(IO.Input.new("SortDirection", "Enum.SortDirection.Ascending"))
	self:addInput(IO.Input.new("MinDate", "0"))
	self:addInput(IO.Input.new("MaxDate", "0"))
	self:addInput(IO.Input.new("PageSize", "50"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Pages", "nil"))
	
	return self
end

function ListVersionsAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local sort = self:getInput("SortDirection").Value or "Enum.SortDirection.Ascending"
	local minDate = self:getInput("MinDate").Value or "0"
	local maxDate = self:getInput("MaxDate").Value or "0"
	local pageSize = self:getInput("PageSize").Value or "50"
	local pagesVar = `pages_{self.Id:gsub("-", "_")}`
	
	self:getOutput("Pages").Value = pagesVar
	
	return `local {pagesVar} = {ds}:ListVersionsAsync({key}, {sort}, {minDate}, {maxDate}, {pageSize})\n`
end

return ListVersionsAsync
