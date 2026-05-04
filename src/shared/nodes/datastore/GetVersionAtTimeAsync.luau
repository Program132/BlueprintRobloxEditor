local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetVersionAtTimeAsync = {}
GetVersionAtTimeAsync.__index = GetVersionAtTimeAsync
setmetatable(GetVersionAtTimeAsync, Node)

function GetVersionAtTimeAsync.new()
	local self = Node.new("DataStore GetVersionAtTimeAsync", NodeType.METHOD)
	setmetatable(self, GetVersionAtTimeAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	self:addInput(IO.Input.new("Timestamp", "0"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Value", "nil"))
	self:addOutput(IO.Output.new("Info", "nil"))
	
	return self
end

function GetVersionAtTimeAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local timestamp = self:getInput("Timestamp").Value or "0"
	local valVar = `value_{self.Id:gsub("-", "_")}`
	local infoVar = `info_{self.Id:gsub("-", "_")}`
	
	self:getOutput("Value").Value = valVar
	self:getOutput("Info").Value = infoVar
	
	return `local {valVar}, {infoVar} = {ds}:GetVersionAtTimeAsync({key}, {timestamp})\n`
end

return GetVersionAtTimeAsync
