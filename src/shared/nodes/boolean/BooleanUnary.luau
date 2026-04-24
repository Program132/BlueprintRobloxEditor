local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local BooleanUnary = {}

function BooleanUnary.create(name, operator)
	local B = {}
	B.__index = B
	setmetatable(B, Node)

	function B.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, B)
		self:editColor(Color3.fromRGB(150, 40, 150))
		self:addInput(IO.Input.new("Value", "false"))
		self:addOutput(IO.Output.new("Result", "false"))
		return self
	end

	function B:toLuau()
		local val = self:getInput("Value").Value
		self:getOutput("Result").Value = `{operator} {val}`
		return ""
	end

	return B
end

return BooleanUnary
