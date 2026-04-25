local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local FromHex = {}
FromHex.__index = FromHex
setmetatable(FromHex, Node)

function FromHex.new()
	local self = Node.new("Color3 fromHex", NodeType.FUNCTION)
	setmetatable(self, FromHex)
	self:editColor(Color3.fromRGB(0, 170, 170))

	self:addInput(IO.Input.new("Hex", "\"#ffffff\""))

	self:addOutput(IO.Output.new("Color", "Color3.fromHex(\"#ffffff\")"))
	self:addOutput(IO.Output.new("H", "0"))
	self:addOutput(IO.Output.new("S", "0"))
	self:addOutput(IO.Output.new("V", "1"))
	self:addOutput(IO.Output.new("Hex", "\"ffffff\""))

	return self
end

function FromHex:toLuau()
	local hex = self:getInput("Hex").Value

	local base = `Color3.fromHex({hex})`
	
	self:getOutput("Color").Value = base
	self:getOutput("H").Value = `(select(1, {base}:ToHSV()))`
	self:getOutput("S").Value = `(select(2, {base}:ToHSV()))`
	self:getOutput("V").Value = `(select(3, {base}:ToHSV()))`
	self:getOutput("Hex").Value = `{base}:ToHex()`

	return ""
end

return FromHex
