local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OSFunc = {}

function OSFunc.create(name, funcName, inputs, outputs, nodeType)
	local O = {}
	O.__index = O
	setmetatable(O, Node)

	function O.new()
		local self = Node.new(name, nodeType or NodeType.FUNCTION)
		setmetatable(self, O)
		self:editColor(Color3.fromRGB(70, 90, 110)) -- Slate Blue for OS
		
		if (nodeType or NodeType.FUNCTION) == NodeType.METHOD then
			self:addInput(IO.Input.new("Exec", ""))
			self:addOutput(IO.Output.new("Exec", ""))
		end

		for _, inp in ipairs(inputs) do
			self:addInput(IO.Input.new(inp.name, inp.default or ""))
		end
		
		for _, out in ipairs(outputs) do
			self:addOutput(IO.Output.new(out.name, out.default or ""))
		end
		
		return self
	end

	function O:toLuau()
		local argValues = {}
		for _, inp in ipairs(inputs) do
			local val = self:getInput(inp.name).Value
			if val == "" then val = inp.default or "nil" end
			table.insert(argValues, val)
		end
		
		local argsStr = table.concat(argValues, ", ")
		local callCode = `os.{funcName}({argsStr})`
		
		if #outputs > 0 then
			if #outputs == 1 then
				self:getOutput(outputs[1].name).Value = callCode
			else
				-- Multi-output handling if needed
			end
		end
		
		if (nodeType or NodeType.FUNCTION) == NodeType.METHOD then
			return callCode .. "\n"
		end
		
		return ""
	end

	return O
end

return OSFunc
