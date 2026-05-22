local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SimpleTween = {}
SimpleTween.__index = SimpleTween
setmetatable(SimpleTween, Node)

function SimpleTween.new()
	local self = Node.new("Simple Tween", NodeType.METHOD)
	setmetatable(self, SimpleTween)
	self:editColor(Color3.fromRGB(255, 130, 0)) -- Warm orange for tweens

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "workspace"))
	self:addInput(IO.Input.new("Property", "\"Transparency\""))
	self:addInput(IO.Input.new("TargetValue", "0.5"))
	self:addInput(IO.Input.new("Duration", "1"))
	self:addInput(IO.Input.new("EasingStyle", "Quad", false, {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Back", "Bounce", "Elastic", "Exponential", "Circular"}, "Enum.EasingStyle"))
	self:addInput(IO.Input.new("EasingDirection", "Out", false, {"In", "Out", "InOut"}, "Enum.EasingDirection"))

	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SimpleTween:toLuau()
	local inst = self:getInput("Instance").Value or "workspace"
	local prop = self:getInput("Property").Value or "\"Transparency\""
	local target = self:getInput("TargetValue").Value or "0.5"
	local duration = self:getInput("Duration").Value or "1"
	
	local style = self:getInput("EasingStyle").Value or ""

	local dir = self:getInput("EasingDirection").Value or ""

	return string.format('game:GetService("TweenService"):Create(%s, TweenInfo.new(%s, %s, %s), {[%s] = %s}):Play()\n', inst, duration, style, dir, prop, target)
end

return SimpleTween
