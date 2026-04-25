local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local New = {}
New.__index = New
setmetatable(New, Node)

function New.new()
	local self = Node.new("Vector2 new", NodeType.FUNCTION)
	setmetatable(self, New)
	self:editColor(Color3.fromRGB(240, 200, 50))

	self:addInput(IO.Input.new("X", "0"))
	self:addInput(IO.Input.new("Y", "0"))

	self:addOutput(IO.Output.new("Vector", "Vector2.new(0, 0)"))
	self:addOutput(IO.Output.new("X", "0"))
	self:addOutput(IO.Output.new("Y", "0"))
	self:addOutput(IO.Output.new("Magnitude", "0"))
	self:addOutput(IO.Output.new("Unit", "Vector2.new(0, 0)"))

	return self
end

function New:toLuau()
	local x = self:getInput("X").Value
	local y = self:getInput("Y").Value

	local base = `Vector2.new({x}, {y})`
	
	self:getOutput("Vector").Value = base
	self:getOutput("X").Value = `{base}.X`
	self:getOutput("Y").Value = `{base}.Y`
	self:getOutput("Magnitude").Value = `{base}.Magnitude`
	self:getOutput("Unit").Value = `{base}.Unit`

	return ""
end

return New
