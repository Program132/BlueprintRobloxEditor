local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local Activate = {}
Activate.__index = Activate
setmetatable(Activate, Node)

function Activate.new()
	local self = Node.new("Activate Tool", NodeType.METHOD)
	setmetatable(self, Activate)
	self:editColor(Color3.fromRGB(0, 180, 100))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Tool", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Activate:toLuau()
	local tool = self:getInput("Tool").Value or "nil"
	return `{tool}:Activate()\n`
end

return Activate
