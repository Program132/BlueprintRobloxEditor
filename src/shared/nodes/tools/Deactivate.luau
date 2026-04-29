local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local Deactivate = {}
Deactivate.__index = Deactivate
setmetatable(Deactivate, Node)

function Deactivate.new()
	local self = Node.new("Deactivate Tool", NodeType.METHOD)
	setmetatable(self, Deactivate)
	self:editColor(Color3.fromRGB(0, 180, 100))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Tool", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Deactivate:toLuau()
	local tool = self:getInput("Tool").Value or "nil"
	return `{tool}:Deactivate()\n`
end

return Deactivate
