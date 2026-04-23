local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)
local HttpService = game:GetService("HttpService")

local ModuleCall = {}
ModuleCall.__index = ModuleCall
setmetatable(ModuleCall, Node)

function ModuleCall.new(dataOrContext)
	local self = Node.new("Module Call", NodeType.METHOD)
	setmetatable(self, ModuleCall)
	
	self:editTitle("Module Call")
	self:editColor(Color3.fromRGB(80, 120, 180))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addOutput(IO.Output.new("Exec", ""))
	
	self:addInput(IO.Input.new("Module", ""))
	self:addInput(IO.Input.new("Method", "MethodName"))
	
	-- State for serialization
	self:addInput(IO.Input.new("__methodData", "{}"))

	if typeof(dataOrContext) == "table" and dataOrContext.Id then
		-- Restore from save
		local methodData = HttpService:JSONDecode(dataOrContext.InputsValues.__methodData or "{}")
		self:applyMethodData(methodData)
		
		-- Restore Method Name if it was changed
		if dataOrContext.InputsValues.Method then
			self:getInput("Method").Value = dataOrContext.InputsValues.Method
		end
	end
	
	return self
end

function ModuleCall:applyMethodData(methodData)
	-- Remove old dynamic pins
	local toRemove = {}
	for _, inp in ipairs(self.Inputs) do
		if inp.Name ~= "Exec" and inp.Name ~= "Module" and inp.Name ~= "Method" and inp.Name ~= "__methodData" then
			table.insert(toRemove, inp.Name)
		end
	end
	for _, name in ipairs(toRemove) do self:removeInput(name) end
	
	toRemove = {}
	for _, out in ipairs(self.Outputs) do
		if out.Name ~= "Exec" then
			table.insert(toRemove, out.Name)
		end
	end
	for _, name in ipairs(toRemove) do self:removeOutput(name) end
	
	-- Add new ones
	for _, p in ipairs(methodData.inputs or {}) do
		self:addInput(IO.Input.new(p.name, ""))
	end
	for _, p in ipairs(methodData.outputs or {}) do
		self:addOutput(IO.Output.new(p.name, ""))
	end
	
	self:getInput("__methodData").Value = HttpService:JSONEncode(methodData)
end

function ModuleCall:Refresh(context)
	local methodName = self:getInput("Method").Value
	local allScripts = context and context.projectScripts
	if not allScripts then return end
	
	local foundMethod = nil
	for _, s in ipairs(allScripts) do
		if s.type == "Module" and s.methods then
			for _, m in ipairs(s.methods) do
				if m.name == methodName then
					foundMethod = m
					break
				end
			end
		end
		if foundMethod then break end
	end
	
	if foundMethod then
		self:applyMethodData(foundMethod)
		self.OnPinsChanged:Fire()
	else
		warn("Method '" .. methodName .. "' not found in any module script defined in the project.")
	end
end

function ModuleCall:toLuau()
	local moduleVar = self:getInput("Module").Value or "nil"
	local methodName = self:getInput("Method").Value
	
	local params = {}
	for _, inp in ipairs(self:getInputs()) do
		if inp.Name ~= "Exec" and inp.Name ~= "Module" and inp.Name ~= "Method" and inp.Name ~= "__methodData" then
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
	
	code ..= moduleVar .. ":" .. methodName .. "(" .. table.concat(params, ", ") .. ")\n"
	
	-- Pass values to outputs
	local i = 1
	for _, out in ipairs(self:getOutputs()) do
		if out.Name ~= "Exec" then
			out.Value = returns[i]
			i += 1
		end
	end
	
	return code
end

return ModuleCall
