local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local MathConstant = {}
MathConstant.__index = MathConstant
setmetatable(MathConstant, Node)

function MathConstant.create(name, value)
	local M = {}
	M.__index = M
	setmetatable(M, MathConstant)

	function M.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, M)
		self:editColor(Color3.fromRGB(40, 150, 70))
		self:addOutput(IO.Output.new("Value", value))
		return self
	end

	function M:toLuau()
		return ""
	end

	return M
end

return MathConstant
