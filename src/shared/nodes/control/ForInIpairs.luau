local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local ForInIpairs = {}
ForInIpairs.__index = ForInIpairs
setmetatable(ForInIpairs, Node)

function ForInIpairs.new()
	local self = Node.new("For In Ipairs", NodeType.CONTROL)
	setmetatable(self, ForInIpairs)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Table", "{}"))
	
	self:addOutput(IO.Output.new("Loop Body", "", true))
	self:addOutput(IO.Output.new("Index", ""))
	self:addOutput(IO.Output.new("Value", ""))
	self:addOutput(IO.Output.new("Completed", "", true))
	
	return self
end

function ForInIpairs:toLuau(block, visited, indentCode)
	local tableVal = self:getInput("Table").Value or "{}"
	
	local suffix = self.Id:gsub("-", ""):sub(1, 4)
	local idxVar = "i_" .. suffix
	local valVar = "v_" .. suffix
	
	local idxOutput = self:getOutput("Index")
	if idxOutput then
		idxOutput.Value = idxVar
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
	
	local code = `for {idxVar}, {valVar} in ipairs({tableVal}) do\n`
	code ..= indentCode(bodyCode)
	code ..= "end\n"
	code ..= completedCode
	
	return code
end

return ForInIpairs
