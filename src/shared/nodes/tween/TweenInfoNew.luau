local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local New = {}
New.__index = New
setmetatable(New, Node)

function New.new()
	local self = Node.new("TweenInfo new", NodeType.FUNCTION)
	setmetatable(self, New)
	self:editColor(Color3.fromRGB(255, 100, 150))

	self:addInput(IO.Input.new("Time", "1"))
	self:addInput(IO.Input.new("EasingStyle", "Enum.EasingStyle.Linear"))
	self:addInput(IO.Input.new("EasingDirection", "Enum.EasingDirection.Out"))
	self:addInput(IO.Input.new("RepeatCount", "0"))
	self:addInput(IO.Input.new("Reverses", "false"))
	self:addInput(IO.Input.new("Delay", "0"))

	self:addOutput(IO.Output.new("TweenInfo", "TweenInfo.new(1)"))

	return self
end

function New:toLuau()
	local t = self:getInput("Time").Value
	local style = self:getInput("EasingStyle").Value
	local dir = self:getInput("EasingDirection").Value
	local count = self:getInput("RepeatCount").Value
	local rev = self:getInput("Reverses").Value
	local delay = self:getInput("Delay").Value

	self:getOutput("TweenInfo").Value = `TweenInfo.new({t}, {style}, {dir}, {count}, {rev}, {delay})`

	return ""
end

return New
