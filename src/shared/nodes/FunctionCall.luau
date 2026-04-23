local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local FunctionCall = {}
FunctionCall.__index = FunctionCall
setmetatable(FunctionCall, Node) 

function FunctionCall.new(nameOrData, inputsOrContext, outputs)
	local name = nameOrData
	local inputs = inputsOrContext
	local finalOutputs = outputs

	if typeof(nameOrData) == "table" and nameOrData.Id then
		-- This is nData from load.
		-- Restore name from hidden input
		if nameOrData.InputsValues then
			name = nameOrData.InputsValues.__functionName or "Unknown"
		end
		-- Reconstruct ports from context (which should be the list of all scripts)
		local context = inputsOrContext
		local allScripts = context and context.projectScripts
		if allScripts and typeof(allScripts) == "table" then
			for _, s in ipairs(allScripts) do
				if s.name == name then
					inputs = s.inputs
					finalOutputs = s.outputs
					found = true
					break
				end
			end
		end
	end

	local self = Node.new("Function Call", NodeType.METHOD)
	setmetatable(self, FunctionCall)
	
	self:editTitle("Call " .. (name or "Unknown"))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addOutput(IO.Output.new("Exec", ""))
	
	-- Hidden state for serialization
	self:addInput(IO.Input.new("__functionName", name or ""))
	
	for _, inp in ipairs(inputs or {}) do
		self:addInput(IO.Input.new(inp.name, ""))
	end
	for _, out in ipairs(finalOutputs or {}) do
		self:addOutput(IO.Output.new(out.name, ""))
	end
	
	return self
end

function FunctionCall:toLuau()
	local functionName = self:getInput("__functionName").Value
	
	local params = {}
	for _, inp in ipairs(self:getInputs()) do
		if inp.Name ~= "Exec" and inp.Name ~= "__functionName" then
			table.insert(params, inp.Value or "nil")
		end
	end
	
	local returns = {}
	for _, out in ipairs(self:getOutputs()) do
		if out.Name ~= "Exec" then
			local varName = "v_" .. out.Name .. "_" .. self.Id:gsub("-", "")
			table.insert(returns, varName)
		end
	end
	
	local code = ""
	if #returns > 0 then
		code = "local " .. table.concat(returns, ", ") .. " = "
	end
	
	code ..= functionName .. "(" .. table.concat(params, ", ") .. ")\n"
	
	-- Pass the variable names to the outputs for subsequent nodes
	local i = 1
	for _, out in ipairs(self:getOutputs()) do
		if out.Name ~= "Exec" then
			out.Value = returns[i]
			i += 1
		end
	end
	
	return code
end

return FunctionCall
