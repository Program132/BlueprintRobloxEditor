local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local RayMethod = {}

function RayMethod.create(name, funcName, inputs, defaultResult)
	local R = {}
	R.__index = R
	setmetatable(R, Node)

	function R.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, R)
		self:editColor(Color3.fromRGB(120, 80, 220)) -- Purple-ish for Ray
		
		self:addInput(IO.Input.new("Ray", ""))
		for _, inp in ipairs(inputs or {}) do
			self:addInput(IO.Input.new(inp.name, ""))
		end
		
		self:addOutput(IO.Output.new("Result", defaultResult or "0"))
		return self
	end

	function R:toLuau()
		local ray = self:getInput("Ray").Value
		local args = {}
		for _, inp in ipairs(inputs or {}) do
			table.insert(args, self:getInput(inp.name).Value)
		end
		
		local argsStr = table.concat(args, ", ")
		self:getOutput("Result").Value = `{ray}:{funcName}({argsStr})`
		return ""
	end

	return R
end

return RayMethod
