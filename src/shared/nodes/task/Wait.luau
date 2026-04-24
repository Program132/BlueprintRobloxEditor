local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Wait = {}
Wait.__index = Wait
setmetatable(Wait, Node)

function Wait.new()
	local self = Node.new("Task Wait", NodeType.METHOD)
	setmetatable(self, Wait)
	self:editColor(Color3.fromRGB(200, 100, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Duration", "0"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Wait:toLuau()
	local d = self:getInput("Duration").Value
	return `task.wait({d})\n`
end

return Wait
