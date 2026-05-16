local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local MathBinary = {}

function MathBinary.create(name, funcName, label1, label2)
	local M = {}
	M.__index = M
	setmetatable(M, Node)

	function M.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, M)
		self:editColor(Color3.fromRGB(40, 150, 70))
		self:addInput(IO.Input.new(label1 or "X", "0", false, nil, "number"))
		self:addInput(IO.Input.new(label2 or "Y", "0", false, nil, "number"))
		self:addOutput(IO.Output.new("Result", "0", false, nil, "number"))
		return self
	end

	function M:toLuau()
		local x = self:getInput(label1 or "X").Value
		local y = self:getInput(label2 or "Y").Value
		self:getOutput("Result").Value = `math.{funcName}({x}, {y})`
		return ""
	end

	return M
end

return MathBinary
