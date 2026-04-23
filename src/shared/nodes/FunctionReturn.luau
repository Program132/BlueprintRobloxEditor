local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local FunctionReturn = {}
FunctionReturn.__index = FunctionReturn
setmetatable(FunctionReturn, Node) 

function FunctionReturn.new(dataOrOutputs, context)
	local outputs = dataOrOutputs
	if typeof(dataOrOutputs) == "table" and dataOrOutputs.Id then
		-- This is nData from load. 'context' is { script = ..., projectScripts = ... }
		outputs = context and context.script and context.script.outputs or {}
	end

	local self = Node.new("Function Return", NodeType.METHOD)
	setmetatable(self, FunctionReturn)
	
	self:addInput(IO.Input.new("Exec", ""))
	for _, out in ipairs(outputs or {}) do
		self:addInput(IO.Input.new(out.name, ""))
	end
	
	return self
end

function FunctionReturn:toLuau()
	local vals = {}
	for _, input in ipairs(self:getInputs()) do
		if input.Name ~= "Exec" then
			table.insert(vals, input.Value or "nil")
		end
	end
	
	if #vals > 0 then
		return "return " .. table.concat(vals, ", ") .. "\n"
	else
		return "return\n"
	end
end

return FunctionReturn
