local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local Error = {}
Error.__index = Error
setmetatable(Error, Node) 

function Error.new()
	local self = Node.new("Error", NodeType.METHOD)
	setmetatable(self, Error)
	self:editColor(Color3.fromRGB(255, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Value", '"Error message"'))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Error:toLuau()
	local valueInput = self:getInput("Value")
	local val = valueInput and valueInput.Value or '""'
	return `error({val})\n`
end

return Error
