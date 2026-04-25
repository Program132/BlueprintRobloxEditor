local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local New = {}
New.__index = New
setmetatable(New, Node)

function New.new()
	local self = Node.new("UDim new", NodeType.FUNCTION)
	setmetatable(self, New)
	self:editColor(Color3.fromRGB(0, 200, 100)) -- Greenish for UDim

	self:addInput(IO.Input.new("Scale", "0"))
	self:addInput(IO.Input.new("Offset", "0"))

	self:addOutput(IO.Output.new("UDim", "UDim.new(0, 0)"))
	self:addOutput(IO.Output.new("Scale", "0"))
	self:addOutput(IO.Output.new("Offset", "0"))

	return self
end

function New:toLuau()
	local scale = self:getInput("Scale").Value
	local offset = self:getInput("Offset").Value

	local base = `UDim.new({scale}, {offset})`
	
	self:getOutput("UDim").Value = base
	self:getOutput("Scale").Value = `{base}.Scale`
	self:getOutput("Offset").Value = `{base}.Offset`

	return ""
end

return New
