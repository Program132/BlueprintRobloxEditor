local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local CFrameMethod = {}

function CFrameMethod.create(name, funcName, inputs, defaultResult)
	local C = {}
	C.__index = C
	setmetatable(C, Node)

	function C.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, C)
		self:editColor(Color3.fromRGB(150, 50, 200)) -- Purple for CFrame
		
		self:addInput(IO.Input.new("CFrame", "CFrame.identity"))
		for _, inp in ipairs(inputs or {}) do
			self:addInput(IO.Input.new(inp.name, inp.default or "0"))
		end
		
		self:addOutput(IO.Output.new("Result", defaultResult or "CFrame.identity"))
		return self
	end

	function C:toLuau()
		local cf = self:getInput("CFrame").Value
		local args = {}
		for _, inp in ipairs(inputs or {}) do
			table.insert(args, self:getInput(inp.name).Value)
		end
		
		local argsStr = table.concat(args, ", ")
		self:getOutput("Result").Value = `{cf}:{funcName}({argsStr})`
		return ""
	end

	return C
end

return CFrameMethod
