local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local FunctionReturn = {}
FunctionReturn.__index = FunctionReturn
setmetatable(FunctionReturn, Node) 

function FunctionReturn.new(dataOrOutputs, contextOrMethodName)
	local outputs = dataOrOutputs
	local methodName = ""

	if typeof(dataOrOutputs) == "table" and dataOrOutputs.Id then
		-- This is nData from load.
		if dataOrOutputs.InputsValues then
			methodName = dataOrOutputs.InputsValues.__methodName or ""
		end
		
		-- Fallback: if methodName is empty but title has it (e.g. from old version)
		if methodName == "" and dataOrOutputs.Title and dataOrOutputs.Title:match("%((.+)%)") then
			methodName = dataOrOutputs.Title:match("%((.+)%)")
		end
		
		outputs = {}
		if contextOrMethodName and contextOrMethodName.script then
			if contextOrMethodName.script.type == "Module" then
				local methods = contextOrMethodName.script.methods or {}
				for _, m in ipairs(methods) do
					if m.name == methodName then
						outputs = m.outputs
						break
					end
				end
			else
				outputs = contextOrMethodName.script.outputs or {}
			end
		end
	else
		-- Direct call (spawn)
		methodName = contextOrMethodName or ""
	end

	local self = Node.new("Function Return", NodeType.METHOD)
	setmetatable(self, FunctionReturn)
	
	if methodName ~= "" then
		self:editTitle("Function Return (" .. methodName .. ")")
	end
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("__methodName", methodName))
	
	for _, out in ipairs(outputs or {}) do
		self:addInput(IO.Input.new(out.name, ""))
	end
	
	return self
end

function FunctionReturn:toLuau()
	local vals = {}
	for _, input in ipairs(self:getInputs()) do
		if input.Name ~= "Exec" and input.Name ~= "__methodName" then
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
