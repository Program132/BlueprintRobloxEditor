local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local IncrementAsync = {}
IncrementAsync.__index = IncrementAsync
setmetatable(IncrementAsync, Node)

function IncrementAsync.new()
	local self = Node.new("DataStore IncrementAsync", NodeType.METHOD)
	setmetatable(self, IncrementAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	self:addInput(IO.Input.new("Delta", "1"))
	self:addInput(IO.Input.new("UserIds", "{}"))
	self:addInput(IO.Input.new("Options", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("NewValue", "0"))
	
	return self
end

function IncrementAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local delta = self:getInput("Delta").Value or "1"
	local userIds = self:getInput("UserIds").Value or "{}"
	local options = self:getInput("Options").Value or "nil"
	local resVar = `newValue_{self.Id:gsub("-", "_")}`
	
	self:getOutput("NewValue").Value = resVar
	
	return `local {resVar} = {ds}:IncrementAsync({key}, {delta}, {userIds}, {options})\n`
end

return IncrementAsync
