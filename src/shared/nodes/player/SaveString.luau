local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SaveString = {}
SaveString.__index = SaveString
setmetatable(SaveString, Node)

function SaveString.new()
	local self = Node.new("Player SaveString", NodeType.METHOD)
	setmetatable(self, SaveString)
	self:editTitle("Save String")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Key", "\"Data\""))
	self:addInput(IO.Input.new("Value", "\"\""))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SaveString:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local key = self:getInput("Key").Value or "\"\""
	local val = self:getInput("Value").Value or "\"\""
	return `{inst}:SaveString({key}, {val})\n`
end

return SaveString
