local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local For = {}
For.__index = For
setmetatable(For, Node) 

function For.new()
	local self = Node.new("For", NodeType.CONTROL)
	setmetatable(self, For)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Start", "1"))
	self:addInput(IO.Input.new("End", "10"))
	self:addInput(IO.Input.new("Step", "1"))
	
	self:addOutput(IO.Output.new("Loop Body", "", true))
	self:addOutput(IO.Output.new("Index", ""))
	self:addOutput(IO.Output.new("Completed", "", true))
	
	return self
end

function For:toLuau(block, visited, indentCode)
	local startVal = self:getInput("Start").Value or "1"
	local endVal = self:getInput("End").Value or "10"
	local stepVal = self:getInput("Step").Value or "1"
	
	-- Provide index value to outputs
	local indexOutput = self:getOutput("Index")
	if indexOutput then
		indexOutput.Value = "i" -- We'll use 'i' as the iterator name
	end
	
	-- PUSH data to connected pins BEFORE running the body
	block:transfer_data_from_node(self)
	
	local bodyVisited = {}
	for k, v in pairs(visited) do bodyVisited[k] = v end
	
	local bodyCode = block:run_from_port(self, "Loop Body", bodyVisited)
	local completedCode = block:run_from_port(self, "Completed", visited)
	
	local code = `for i = {startVal}, {endVal}, {stepVal} do\n`
	code ..= indentCode(bodyCode)
	code ..= "end\n"
	code ..= completedCode
	
	return code
end

return For
