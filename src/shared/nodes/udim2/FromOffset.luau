local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local FromOffset = {}
FromOffset.__index = FromOffset
setmetatable(FromOffset, Node)

function FromOffset.new()
	local self = Node.new("UDim2 fromOffset", NodeType.FUNCTION)
	setmetatable(self, FromOffset)
	self:editColor(Color3.fromRGB(0, 180, 200))

	self:addInput(IO.Input.new("xOffset", "0"))
	self:addInput(IO.Input.new("yOffset", "0"))

	self:addOutput(IO.Output.new("UDim2", "UDim2.fromOffset(0, 0)"))

	return self
end

function FromOffset:toLuau()
	local xo = self:getInput("xOffset").Value
	local yo = self:getInput("yOffset").Value

	self:getOutput("UDim2").Value = `UDim2.fromOffset({xo}, {yo})`

	return ""
end

return FromOffset
