local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local Print = {}
Print.__index = Print
setmetatable(Print, Node) 

function Print.new()
	local self = Node.new("Print String", NodeType.METHOD)
	setmetatable(self, Print)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Value", '"Hello"'))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Print:toLuau()
	local valueInput = self:getInput("Value")
	local val = valueInput and valueInput.Value or '""'
	return `print({val})\n`
end

return Print
