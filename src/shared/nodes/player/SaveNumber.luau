local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SaveNumber = {}
SaveNumber.__index = SaveNumber
setmetatable(SaveNumber, Node)

function SaveNumber.new()
	local self = Node.new("Player SaveNumber", NodeType.METHOD)
	setmetatable(self, SaveNumber)
	self:editTitle("Save Number")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Key", "\"Data\""))
	self:addInput(IO.Input.new("Value", "0"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SaveNumber:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local key = self:getInput("Key").Value or "\"\""
	local val = self:getInput("Value").Value or "0"
	return `{inst}:SaveNumber({key}, {val})\n`
end

return SaveNumber
