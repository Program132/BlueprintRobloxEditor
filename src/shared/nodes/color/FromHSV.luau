local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local FromHSV = {}
FromHSV.__index = FromHSV
setmetatable(FromHSV, Node)

function FromHSV.new()
	local self = Node.new("Color3 fromHSV", NodeType.FUNCTION)
	setmetatable(self, FromHSV)
	self:editColor(Color3.fromRGB(0, 170, 170))

	self:addInput(IO.Input.new("H", "0"))
	self:addInput(IO.Input.new("S", "1"))
	self:addInput(IO.Input.new("V", "1"))

	self:addOutput(IO.Output.new("Color", "Color3.fromHSV(0, 1, 1)"))
	self:addOutput(IO.Output.new("H", "0"))
	self:addOutput(IO.Output.new("S", "1"))
	self:addOutput(IO.Output.new("V", "1"))
	self:addOutput(IO.Output.new("Hex", "\"ff0000\""))

	return self
end

function FromHSV:toLuau()
	local h = self:getInput("H").Value
	local s = self:getInput("S").Value
	local v = self:getInput("V").Value

	local base = `Color3.fromHSV({h}, {s}, {v})`
	
	self:getOutput("Color").Value = base
	self:getOutput("H").Value = `(select(1, {base}:ToHSV()))`
	self:getOutput("S").Value = `(select(2, {base}:ToHSV()))`
	self:getOutput("V").Value = `(select(3, {base}:ToHSV()))`
	self:getOutput("Hex").Value = `{base}:ToHex()`

	return ""
end

return FromHSV
