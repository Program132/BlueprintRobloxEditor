local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetVersionAsync = {}
GetVersionAsync.__index = GetVersionAsync
setmetatable(GetVersionAsync, Node)

function GetVersionAsync.new()
	local self = Node.new("DataStore GetVersionAsync", NodeType.FUNCTION)
	setmetatable(self, GetVersionAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	self:addInput(IO.Input.new("Version", '""'))
	
	self:addOutput(IO.Output.new("Value", "nil"))
	self:addOutput(IO.Output.new("Info", "nil"))
	
	return self
end

function GetVersionAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local version = self:getInput("Version").Value or '""'
	
	self:getOutput("Value").Value = `(select(1, {ds}:GetVersionAsync({key}, {version})))`
	self:getOutput("Info").Value = `(select(2, {ds}:GetVersionAsync({key}, {version})))`
	
	return ""
end

return GetVersionAsync
