local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Concat = {}
Concat.__index = Concat
setmetatable(Concat, Node)

function Concat.new()
	local self = Node.new("Concat", NodeType.FUNCTION)
	setmetatable(self, Concat)
	self:editColor(Color3.fromRGB(180, 70, 70)) -- Match String category color

	self:addInput(IO.Input.new("A", '""'))
	self:addInput(IO.Input.new("B", '""'))

	self:addOutput(IO.Output.new("Result", '""'))

	return self
end

function Concat:toLuau()
	local a = self:getInput("A").Value
	local b = self:getInput("B").Value

	self:getOutput("Result").Value = `({a} .. {b})`

	return ""
end

return Concat
