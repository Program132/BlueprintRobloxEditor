local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local UpdateAsync = {}
UpdateAsync.__index = UpdateAsync
setmetatable(UpdateAsync, Node)

function UpdateAsync.new()
	local self = Node.new("DataStore UpdateAsync", NodeType.METHOD)
	setmetatable(self, UpdateAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	self:addInput(IO.Input.new("TransformFunction", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Value", "nil"))
	self:addOutput(IO.Output.new("KeyInfo", "nil"))
	
	return self
end

function UpdateAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local transform = self:getInput("TransformFunction").Value or "nil"
	local valVar = `value_{self.Id:gsub("-", "_")}`
	local infoVar = `info_{self.Id:gsub("-", "_")}`
	
	self:getOutput("Value").Value = valVar
	self:getOutput("KeyInfo").Value = infoVar
	
	return `local {valVar}, {infoVar} = {ds}:UpdateAsync({key}, {transform})\n`
end

return UpdateAsync
