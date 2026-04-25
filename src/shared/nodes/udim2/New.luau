local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local New = {}
New.__index = New
setmetatable(New, Node)

function New.new()
	local self = Node.new("UDim2 new", NodeType.FUNCTION)
	setmetatable(self, New)
	self:editColor(Color3.fromRGB(0, 180, 200)) -- Teal for UDim2

	self:addInput(IO.Input.new("xScale", "0"))
	self:addInput(IO.Input.new("xOffset", "0"))
	self:addInput(IO.Input.new("yScale", "0"))
	self:addInput(IO.Input.new("yOffset", "0"))

	self:addOutput(IO.Output.new("UDim2", "UDim2.new(0, 0, 0, 0)"))
	self:addOutput(IO.Output.new("X", "UDim.new(0, 0)"))
	self:addOutput(IO.Output.new("Y", "UDim.new(0, 0)"))

	return self
end

function New:toLuau()
	local xs = self:getInput("xScale").Value
	local xo = self:getInput("xOffset").Value
	local ys = self:getInput("yScale").Value
	local yo = self:getInput("yOffset").Value

	local base = `UDim2.new({xs}, {xo}, {ys}, {yo})`
	
	self:getOutput("UDim2").Value = base
	self:getOutput("X").Value = `{base}.X`
	self:getOutput("Y").Value = `{base}.Y`

	return ""
end

return New
