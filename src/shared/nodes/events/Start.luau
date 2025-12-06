local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Start = {}
Start.__index = Start
setmetatable(Start, Node) 

function Start.new()
	local self = Node.new("Start Event", NodeType.EVENT)
	setmetatable(self, Start)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Start:toLuau()
	return ""
end

return Start
