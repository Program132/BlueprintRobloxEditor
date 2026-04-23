local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local FunctionEntry = {}
FunctionEntry.__index = FunctionEntry
setmetatable(FunctionEntry, Node) 

function FunctionEntry.new(dataOrInputs, contextOrMethodName)
	local inputs = dataOrInputs
	local methodName = ""

	if typeof(dataOrInputs) == "table" and dataOrInputs.Id then
		-- This is nData from load.
		inputs = contextOrMethodName and contextOrMethodName.script and contextOrMethodName.script.inputs or {}
		if dataOrInputs.InputsValues then
			methodName = dataOrInputs.InputsValues.__methodName or ""
		end
		-- If it's a module method, find the correct inputs for THIS method
		if contextOrMethodName and contextOrMethodName.script and contextOrMethodName.script.type == "Module" then
			local methods = contextOrMethodName.script.methods or {}
			for _, m in ipairs(methods) do
				if m.name == methodName then
					inputs = m.inputs
					break
				end
			end
		end
	else
		-- Direct call (spawn)
		methodName = contextOrMethodName or ""
	end

	local self = Node.new("Function Entry", NodeType.EVENT)
	setmetatable(self, FunctionEntry)
	
	if methodName ~= "" then
		self:editTitle("Function Entry (" .. methodName .. ")")
	end
	
	self:addInput(IO.Input.new("__methodName", methodName))
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
