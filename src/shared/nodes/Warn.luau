local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local Warn = {}
Warn.__index = Warn
setmetatable(Warn, Node) 

function Warn.new()
	local self = Node.new("Warn", NodeType.METHOD)
	setmetatable(self, Warn)
	self:editColor(Color3.fromRGB(255, 160, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Value", "\"Warning\"", false, nil, "variant"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Warn:toLuau()
	local valueInput = self:getInput("Value")
	local val = valueInput and valueInput.Value or '""'
	return `warn({val})\n`
end

return Warn
