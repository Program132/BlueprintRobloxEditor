local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local FunctionEntry = {}
FunctionEntry.__index = FunctionEntry
setmetatable(FunctionEntry, Node) 

function FunctionEntry.new(dataOrInputs, context)
	local inputs = dataOrInputs
	if typeof(dataOrInputs) == "table" and dataOrInputs.Id then
		-- This is nData from load. 'context' is { script = ..., projectScripts = ... }
		inputs = context and context.script and context.script.inputs or {}
	end

	local self = Node.new("Function Entry", NodeType.EVENT)
	setmetatable(self, FunctionEntry)
	
	self:addOutput(IO.Output.new("Exec", ""))
	for _, inp in ipairs(inputs or {}) do
		self:addOutput(IO.Output.new(inp.name, ""))
	end
	
	return self
end

function FunctionEntry:toLuau()
	-- The entry node doesn't generate 'function' (that's handled by script wrapping)
	-- but it provides the parameter names to its outputs
	for _, output in ipairs(self:getOutputs()) do
		if output.Name ~= "Exec" then
			output.Value = output.Name
		end
	end
	return ""
end

return FunctionEntry
