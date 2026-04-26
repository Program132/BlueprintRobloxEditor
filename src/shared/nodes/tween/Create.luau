local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Create = {}
Create.__index = Create
setmetatable(Create, Node)

function Create.new()
	local self = Node.new("Tween Create", NodeType.FUNCTION)
	setmetatable(self, Create)
	self:editColor(Color3.fromRGB(255, 100, 150))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("TweenInfo", "TweenInfo.new(1)"))
	self:addInput(IO.Input.new("Goals", "{}"))

	self:addOutput(IO.Output.new("Tween", "nil"))

	return self
end

function Create:toLuau()
	local inst = self:getInput("Instance").Value
	local info = self:getInput("TweenInfo").Value
	local goals = self:getInput("Goals").Value

	self:getOutput("Tween").Value = `game:GetService("TweenService"):Create({inst}, {info}, {goals})`

	return ""
end

return Create
