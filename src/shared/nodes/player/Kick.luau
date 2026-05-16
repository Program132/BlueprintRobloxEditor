local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Kick = {}
Kick.__index = Kick
setmetatable(Kick, Node)

function Kick.new()
	local self = Node.new("Player Kick", NodeType.METHOD)
	setmetatable(self, Kick)
	self:editTitle("Kick Player")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Message", "\"Kicked from the game.\""))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function Kick:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local msg = self:getInput("Message").Value or "\"\""
	return `{inst}:Kick({msg})\n`
end

return Kick
