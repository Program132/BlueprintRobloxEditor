local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Dot = {}
Dot.__index = Dot
setmetatable(Dot, Node)

function Dot.new()
	local self = Node.new("Vector2 Dot", NodeType.FUNCTION)
	setmetatable(self, Dot)
	self:editColor(Color3.fromRGB(240, 200, 50))

	self:addInput(IO.Input.new("A", "Vector2.new(1, 0)"))
	self:addInput(IO.Input.new("B", "Vector2.new(0, 1)"))

	self:addOutput(IO.Output.new("Result", "0"))

	return self
end

function Dot:toLuau()
	local a = self:getInput("A").Value
	local b = self:getInput("B").Value

	self:getOutput("Result").Value = `{a}:Dot({b})`

	return ""
end

return Dot
