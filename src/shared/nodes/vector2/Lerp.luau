local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Lerp = {}
Lerp.__index = Lerp
setmetatable(Lerp, Node)

function Lerp.new()
	local self = Node.new("Vector2 Lerp", NodeType.FUNCTION)
	setmetatable(self, Lerp)
	self:editColor(Color3.fromRGB(240, 200, 50))

	self:addInput(IO.Input.new("Vector", "Vector2.new(0, 0)"))
	self:addInput(IO.Input.new("Target", "Vector2.new(1, 1)"))
	self:addInput(IO.Input.new("Alpha", "0.5"))

	self:addOutput(IO.Output.new("Result", "Vector2.new(0.5, 0.5)"))

	return self
end

function Lerp:toLuau()
	local vector = self:getInput("Vector").Value
	local target = self:getInput("Target").Value
	local alpha = self:getInput("Alpha").Value

	self:getOutput("Result").Value = `{vector}:Lerp({target}, {alpha})`

	return ""
end

return Lerp
