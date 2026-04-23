local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local If = {}
If.__index = If
setmetatable(If, Node) 

function If.new()
	local self = Node.new("If", NodeType.CONTROL)
	setmetatable(self, If)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Condition", "false"))
	
	self:addOutput(IO.Output.new("True", "", true))
	self:addOutput(IO.Output.new("False", "", true))
	self:addOutput(IO.Output.new("Completed", "", true))
	
	return self
end

function If:toLuau(block, visited, indentCode)
	local conditionInput = self:getInput("Condition")
	local cond = conditionInput and conditionInput.Value or "false"
	
	-- We want the branches to be independent but they might rejoin later.
	-- For If, the Completed pin handles the "after" logic.
	
	local trueCode = block:run_from_port(self, "True", visited)
	local falseCode = block:run_from_port(self, "False", visited)
	local completedCode = block:run_from_port(self, "Completed", visited)
	
	local code = `if {cond} then\n`
	code ..= indentCode(trueCode)
	if falseCode ~= "" then
		code ..= "else\n"
		code ..= indentCode(falseCode)
	end
	code ..= "end\n"
	code ..= completedCode
	
	return code
end

return If
