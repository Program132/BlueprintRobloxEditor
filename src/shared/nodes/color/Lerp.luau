local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Lerp = {}
Lerp.__index = Lerp
setmetatable(Lerp, Node)

function Lerp.new()
	local self = Node.new("Color3 Lerp", NodeType.FUNCTION)
	setmetatable(self, Lerp)
	self:editColor(Color3.fromRGB(0, 170, 170))

	self:addInput(IO.Input.new("Color", "Color3.new(1, 1, 1)"))
	self:addInput(IO.Input.new("Target", "Color3.new(0, 0, 0)"))
	self:addInput(IO.Input.new("Alpha", "0.5"))

	self:addOutput(IO.Output.new("Result", "Color3.new(0.5, 0.5, 0.5)"))

	return self
end

function Lerp:toLuau()
	local color = self:getInput("Color").Value
	local target = self:getInput("Target").Value
	local alpha = self:getInput("Alpha").Value

	self:getOutput("Result").Value = `{color}:Lerp({target}, {alpha})`

	return ""
end

return Lerp
