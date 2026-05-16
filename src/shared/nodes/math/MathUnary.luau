local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local MathUnary = {}

function MathUnary.create(name, funcName)
	local M = {}
	M.__index = M
	setmetatable(M, Node)

	function M.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, M)
		self:editColor(Color3.fromRGB(40, 150, 70))
		self:addInput(IO.Input.new("X", "0", false, nil, "number"))
		self:addOutput(IO.Output.new("Result", "0", false, nil, "number"))
		return self
	end

	function M:toLuau()
		local x = self:getInput("X").Value
		self:getOutput("Result").Value = `math.{funcName}({x})`
		return ""
	end

	return M
end

return MathUnary
