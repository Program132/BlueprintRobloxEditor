local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local FromRGB = {}
FromRGB.__index = FromRGB
setmetatable(FromRGB, Node)

function FromRGB.new()
	local self = Node.new("Color3 fromRGB", NodeType.FUNCTION)
	setmetatable(self, FromRGB)
	self:editColor(Color3.fromRGB(0, 170, 170))

	self:addInput(IO.Input.new("R", "255"))
	self:addInput(IO.Input.new("G", "255"))
	self:addInput(IO.Input.new("B", "255"))

	self:addOutput(IO.Output.new("Color", "Color3.fromRGB(255, 255, 255)"))
	self:addOutput(IO.Output.new("H", "0"))
	self:addOutput(IO.Output.new("S", "0"))
	self:addOutput(IO.Output.new("V", "1"))
	self:addOutput(IO.Output.new("Hex", "\"ffffff\""))

	return self
end

function FromRGB:toLuau()
	local r = self:getInput("R").Value
	local g = self:getInput("G").Value
	local b = self:getInput("B").Value

	local base = `Color3.fromRGB({r}, {g}, {b})`
	
	self:getOutput("Color").Value = base
	self:getOutput("H").Value = `(select(1, {base}:ToHSV()))`
	self:getOutput("S").Value = `(select(2, {base}:ToHSV()))`
	self:getOutput("V").Value = `(select(3, {base}:ToHSV()))`
	self:getOutput("Hex").Value = `{base}:ToHex()`

	return ""
end

return FromRGB
