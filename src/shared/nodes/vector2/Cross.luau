local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Cross = {}
Cross.__index = Cross
setmetatable(Cross, Node)

function Cross.new()
	local self = Node.new("Vector2 Cross", NodeType.FUNCTION)
	setmetatable(self, Cross)
	self:editColor(Color3.fromRGB(240, 200, 50))

	self:addInput(IO.Input.new("A", "Vector2.new(1, 0)"))
	self:addInput(IO.Input.new("B", "Vector2.new(0, 1)"))

	self:addOutput(IO.Output.new("Result", "0"))

	return self
end

function Cross:toLuau()
	local a = self:getInput("A").Value
	local b = self:getInput("B").Value

	self:getOutput("Result").Value = `{a}:Cross({b})`

	return ""
end

return Cross
