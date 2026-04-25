local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local FromScale = {}
FromScale.__index = FromScale
setmetatable(FromScale, Node)

function FromScale.new()
	local self = Node.new("UDim2 fromScale", NodeType.FUNCTION)
	setmetatable(self, FromScale)
	self:editColor(Color3.fromRGB(0, 180, 200))

	self:addInput(IO.Input.new("xScale", "0"))
	self:addInput(IO.Input.new("yScale", "0"))

	self:addOutput(IO.Output.new("UDim2", "UDim2.fromScale(0, 0)"))

	return self
end

function FromScale:toLuau()
	local xs = self:getInput("xScale").Value
	local ys = self:getInput("yScale").Value

	self:getOutput("UDim2").Value = `UDim2.fromScale({xs}, {ys})`

	return ""
end

return FromScale
