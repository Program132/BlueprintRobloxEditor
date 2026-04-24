local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Synchronize = {}
Synchronize.__index = Synchronize
setmetatable(Synchronize, Node)

function Synchronize.new()
	local self = Node.new("Task Synchronize", NodeType.METHOD)
	setmetatable(self, Synchronize)
	self:editColor(Color3.fromRGB(200, 100, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Synchronize:toLuau()
	return "task.synchronize()\n"
end

return Synchronize
