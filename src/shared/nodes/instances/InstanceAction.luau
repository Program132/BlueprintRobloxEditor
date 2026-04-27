local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local InstanceAction = {}

function InstanceAction.create(name, funcName, inputs)
	local I = {}
	I.__index = I
	setmetatable(I, Node)

	function I.new()
		local self = Node.new(name, NodeType.METHOD)
		setmetatable(self, I)
		self:editColor(Color3.fromRGB(100, 180, 255))
		
		self:addInput(IO.Input.new("Exec", ""))
		self:addInput(IO.Input.new("Instance", "workspace"))
		for _, inp in ipairs(inputs or {}) do
			self:addInput(IO.Input.new(inp.name, inp.default or '""'))
		end
		
		self:addOutput(IO.Output.new("Exec", ""))
		return self
	end

	function I:toLuau()
		local inst = self:getInput("Instance").Value
		local args = {}
		for _, inp in ipairs(inputs or {}) do
			table.insert(args, self:getInput(inp.name).Value)
		end
		
		local argsStr = table.concat(args, ", ")
		return `{inst}:{funcName}({argsStr})\n`
	end

	return I
end

return InstanceAction
