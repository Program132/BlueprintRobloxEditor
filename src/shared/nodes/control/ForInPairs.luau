local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local ForInPairs = {}
ForInPairs.__index = ForInPairs
setmetatable(ForInPairs, Node)

function ForInPairs.new()
	local self = Node.new("For In Pairs", NodeType.CONTROL)
	setmetatable(self, ForInPairs)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Table", "{}"))
	
	self:addOutput(IO.Output.new("Loop Body", "", true))
	self:addOutput(IO.Output.new("Key", ""))
	self:addOutput(IO.Output.new("Value", ""))
	self:addOutput(IO.Output.new("Completed", "", true))
	
	return self
end

function ForInPairs:toLuau(block, visited, indentCode)
	local tableVal = self:getInput("Table").Value or "{}"
	
	local suffix = self.Id:gsub("-", ""):sub(1, 4)
	local keyVar = "k_" .. suffix
	local valVar = "v_" .. suffix
	
	local keyOutput = self:getOutput("Key")
	if keyOutput then
		keyOutput.Value = keyVar
	end
	
	local valOutput = self:getOutput("Value")
	if valOutput then
		valOutput.Value = valVar
	end
	
	-- PUSH data to connected pins BEFORE running the body
	block:transfer_data_from_node(self)
	
	local bodyVisited = {}
	for k, v in pairs(visited) do bodyVisited[k] = v end
	
	local bodyCode = block:run_from_port(self, "Loop Body", bodyVisited)
	local completedCode = block:run_from_port(self, "Completed", visited)
	
	local code = `for {keyVar}, {valVar} in pairs({tableVal}) do\n`
	code ..= indentCode(bodyCode)
	code ..= "end\n"
	code ..= completedCode
	
	return code
end

return ForInPairs
