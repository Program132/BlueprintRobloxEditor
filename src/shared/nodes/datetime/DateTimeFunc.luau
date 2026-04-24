local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local DateTimeFunc = {}

function DateTimeFunc.create(name, funcName, inputs, outputs, nodeType, isConstructor, isProperty)
	local D = {}
	D.__index = D
	setmetatable(D, Node)

	function D.new()
		local self = Node.new(name, nodeType or NodeType.FUNCTION)
		setmetatable(self, D)
		self:editColor(Color3.fromRGB(75, 0, 130)) -- Indigo for DateTime
		self.isProperty = isProperty
		
		if (nodeType or NodeType.FUNCTION) == NodeType.METHOD then
			self:addInput(IO.Input.new("Exec", ""))
			self:addOutput(IO.Output.new("Exec", ""))
		end

		if not isConstructor then
			self:addInput(IO.Input.new("DateTime", "nil"))
		end

		for _, inp in ipairs(inputs) do
			self:addInput(IO.Input.new(inp.name, inp.default or ""))
		end
		
		for _, out in ipairs(outputs) do
			self:addOutput(IO.Output.new(out.name, out.default or ""))
		end
		
		return self
	end

	function D:toLuau()
		local argValues = {}
		for _, inp in ipairs(inputs) do
			local val = self:getInput(inp.name).Value
			if val == "" then val = inp.default or "nil" end
			table.insert(argValues, val)
		end
		
		local argsStr = table.concat(argValues, ", ")
		local callCode = ""
		
		if isConstructor then
			callCode = `DateTime.{funcName}({argsStr})`
		elseif self.isProperty then
			local dt = self:getInput("DateTime").Value
			callCode = `{dt}.{funcName}`
		else
			local dt = self:getInput("DateTime").Value
			callCode = `{dt}:{funcName}({argsStr})`
		end
		
		if #outputs > 0 then
			if #outputs == 1 then
				self:getOutput(outputs[1].name).Value = callCode
			else
				-- Multi-output handling
			end
		end
		
		if (nodeType or NodeType.FUNCTION) == NodeType.METHOD then
			return callCode .. "\n"
		end
		
		return ""
	end

	return D
end

return DateTimeFunc
