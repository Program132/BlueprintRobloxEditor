local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Vector2Method = {}

function Vector2Method.create(name, funcName, inputs, defaultResult)
	local V = {}
	V.__index = V
	setmetatable(V, Node)

	function V.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, V)
		self:editColor(Color3.fromRGB(240, 200, 50))
		
		self:addInput(IO.Input.new("Vector", "Vector2.new(0, 0)"))
		for _, inp in ipairs(inputs or {}) do
			self:addInput(IO.Input.new(inp.name, inp.default or "0"))
		end
		
		self:addOutput(IO.Output.new("Result", defaultResult or "0"))
		return self
	end

	function V:toLuau()
		local vector = self:getInput("Vector").Value
		local args = {}
		for _, inp in ipairs(inputs or {}) do
			table.insert(args, self:getInput(inp.name).Value)
		end
		
		local argsStr = table.concat(args, ", ")
		self:getOutput("Result").Value = `{vector}:{funcName}({argsStr})`
		return ""
	end

	return V
end

return Vector2Method
