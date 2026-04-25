local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OperatorBinary = {}

function OperatorBinary.create(name, operator)
	local M = {}
	M.__index = M
	setmetatable(M, Node)

	function M.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, M)
		self:editColor(Color3.fromRGB(40, 150, 70))
		self:addInput(IO.Input.new("A", "0"))
		self:addInput(IO.Input.new("B", "0"))
		self:addOutput(IO.Output.new("Result", "0"))
		return self
	end

	function M:toLuau()
		local a = self:getInput("A").Value
		local b = self:getInput("B").Value
		self:getOutput("Result").Value = `({a} {operator} {b})`
		return ""
	end

	return M
end

return OperatorBinary
