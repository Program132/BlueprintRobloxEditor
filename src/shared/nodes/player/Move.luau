local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Move = {}
Move.__index = Move
setmetatable(Move, Node)

function Move.new()
	local self = Node.new("Player Move", NodeType.METHOD)
	setmetatable(self, Move)
	self:editTitle("Move Player")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Direction", "Vector3.new(0,0,0)"))
	self:addInput(IO.Input.new("RelativeToCamera", "false"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function Move:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local dir = self:getInput("Direction").Value or "Vector3.new(0,0,0)"
	local cam = self:getInput("RelativeToCamera").Value or "false"
	return `{inst}:Move({dir}, {cam})\n`
end

return Move
