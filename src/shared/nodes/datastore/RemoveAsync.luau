local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local RemoveAsync = {}
RemoveAsync.__index = RemoveAsync
setmetatable(RemoveAsync, Node)

function RemoveAsync.new()
	local self = Node.new("DataStore RemoveAsync", NodeType.METHOD)
	setmetatable(self, RemoveAsync)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("DataStore", "nil"))
	self:addInput(IO.Input.new("Key", '""'))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("OldValue", "nil"))
	self:addOutput(IO.Output.new("KeyInfo", "nil"))
	
	return self
end

function RemoveAsync:toLuau()
	local ds = self:getInput("DataStore").Value or "nil"
	local key = self:getInput("Key").Value or '""'
	local valVar = `oldValue_{self.Id:gsub("-", "_")}`
	local infoVar = `info_{self.Id:gsub("-", "_")}`
	
	self:getOutput("OldValue").Value = valVar
	self:getOutput("KeyInfo").Value = infoVar
	
	return `local {valVar}, {infoVar} = {ds}:RemoveAsync({key})\n`
end

return RemoveAsync
