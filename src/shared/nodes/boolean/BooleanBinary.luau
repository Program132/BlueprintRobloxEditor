local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local BooleanBinary = {}

function BooleanBinary.create(name, operator, label1, label2)
	local B = {}
	B.__index = B
	setmetatable(B, Node)

	function B.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, B)
		self:editColor(Color3.fromRGB(150, 40, 150)) -- Purple for logic
		self:addInput(IO.Input.new(label1 or "A", "false"))
		self:addInput(IO.Input.new(label2 or "B", "false"))
		self:addOutput(IO.Output.new("Result", "false"))
		return self
	end

	function B:toLuau()
		local a = self:getInput(label1 or "A").Value
		local b = self:getInput(label2 or "B").Value
		self:getOutput("Result").Value = `({a} {operator} {b})`
		return ""
	end

	return B
end

return BooleanBinary
