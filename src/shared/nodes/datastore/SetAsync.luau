local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SetAsync = {}
SetAsync.__index = SetAsync
setmetatable(SetAsync, Node)

function SetAsync.new()
	local self = Node.new("DataStore SetAsync", NodeType.METHOD)
	setmetatable(self, SetAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	self:addInput(IO.Input.new("Value", "nil"))
	self:addInput(IO.Input.new("UserIds", "{}"))
	self:addInput(IO.Input.new("Options", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("KeyInfo", "nil"))
	
	return self
end

function SetAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local value = self:getInput("Value").Value or "nil"
	local userIds = self:getInput("UserIds").Value or "{}"
	local options = self:getInput("Options").Value or "nil"
	local infoVar = `info_{self.Id:gsub("-", "_")}`
	
	self:getOutput("KeyInfo").Value = infoVar
	
	return `local {infoVar} = {ds}:SetAsync({key}, {value}, {userIds}, {options})\n`
end

return SetAsync
