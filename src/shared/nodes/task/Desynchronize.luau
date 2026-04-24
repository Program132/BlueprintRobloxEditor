local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Desynchronize = {}
Desynchronize.__index = Desynchronize
setmetatable(Desynchronize, Node)

function Desynchronize.new()
	local self = Node.new("Task Desynchronize", NodeType.METHOD)
	setmetatable(self, Desynchronize)
	self:editColor(Color3.fromRGB(200, 100, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Desynchronize:toLuau()
	return "task.desynchronize()\n"
end

return Desynchronize
