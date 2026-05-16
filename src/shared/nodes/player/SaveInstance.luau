local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SaveInstance = {}
SaveInstance.__index = SaveInstance
setmetatable(SaveInstance, Node)

function SaveInstance.new()
	local self = Node.new("Player SaveInstance", NodeType.METHOD)
	setmetatable(self, SaveInstance)
	self:editTitle("Save Instance")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Key", "\"Data\""))
	self:addInput(IO.Input.new("Value", "nil"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SaveInstance:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local key = self:getInput("Key").Value or "\"\""
	local val = self:getInput("Value").Value or "nil"
	return `{inst}:SaveInstance({key}, {val})\n`
end

return SaveInstance
