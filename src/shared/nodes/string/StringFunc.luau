local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local StringFunc = {}

function StringFunc.create(name, funcName, inputs, outputs)
	local S = {}
	S.__index = S
	setmetatable(S, Node)

	function S.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, S)
		self:editColor(Color3.fromRGB(180, 70, 70))
		
		for _, inp in ipairs(inputs) do
			self:addInput(IO.Input.new(inp.name, inp.default or '""'))
		end
		
		for _, out in ipairs(outputs) do
			self:addOutput(IO.Output.new(out.name, out.default or '""'))
		end
		
		return self
	end

	function S:toLuau()
		local argValues = {}
		for _, inp in ipairs(inputs) do
			table.insert(argValues, self:getInput(inp.name).Value)
		end
		
		local argsStr = table.concat(argValues, ", ")
		
		if #outputs == 1 then
			self:getOutput(outputs[1].name).Value = `string.{funcName}({argsStr})`
		else
			-- For multiple outputs, we'd need a way to unpack or handle it.
			-- For now, let's assume the first output gets the main result.
			self:getOutput(outputs[1].name).Value = `string.{funcName}({argsStr})`
		end
		
		return ""
	end

	return S
end

return StringFunc
