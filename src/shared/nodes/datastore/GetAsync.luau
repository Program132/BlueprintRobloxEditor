local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetAsync = {}
GetAsync.__index = GetAsync
setmetatable(GetAsync, Node)

function GetAsync.new()
	local self = Node.new("DataStore GetAsync", NodeType.FUNCTION)
	setmetatable(self, GetAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	self:addInput(IO.Input.new("Options", "nil"))
	
	self:addOutput(IO.Output.new("Value", "nil"))
	self:addOutput(IO.Output.new("Info", "nil"))
	
	return self
end

function GetAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local options = self:getInput("Options").Value or "nil"
	
	self:getOutput("Value").Value = `(select(1, {ds}:GetAsync({key}, {options})))`
	self:getOutput("Info").Value = `(select(2, {ds}:GetAsync({key}, {options})))`
	
	return ""
end

return GetAsync
