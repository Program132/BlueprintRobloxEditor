local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SaveBoolean = {}
SaveBoolean.__index = SaveBoolean
setmetatable(SaveBoolean, Node)

function SaveBoolean.new()
	local self = Node.new("Player SaveBoolean", NodeType.METHOD)
	setmetatable(self, SaveBoolean)
	self:editTitle("Save Boolean")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Key", "\"Data\""))
	self:addInput(IO.Input.new("Value", "false"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SaveBoolean:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local key = self:getInput("Key").Value or "\"\""
	local val = self:getInput("Value").Value or "false"
	return `{inst}:SaveBoolean({key}, {val})\n`
end

return SaveBoolean
