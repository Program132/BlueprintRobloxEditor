local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local While = {}
While.__index = While
setmetatable(While, Node) 

function While.new()
	local self = Node.new("While", NodeType.CONTROL)
	setmetatable(self, While)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Condition", "true"))
	
	self:addOutput(IO.Output.new("Loop Body", "", true))
	self:addOutput(IO.Output.new("Completed", "", true))
	
	return self
end

function While:toLuau(block, visited, indentCode)
	local conditionInput = self:getInput("Condition")
	local cond = conditionInput and conditionInput.Value or "true"
	
	-- For loops, we need to be careful with 'visited' because the loop body 
	-- might contain nodes that should be allowed to run again in other contexts,
	-- but within the same block, we usually want to avoid infinite recursion in the compiler.
	-- However, the generated code IS a loop, so it's fine.
	
	-- We pass a CLONE of visited to the loop body so it doesn't "exhaust" nodes for the 'Completed' path?
	-- Actually, nodes inside the loop should probably be fresh.
	local bodyVisited = {}
	for k, v in pairs(visited) do bodyVisited[k] = v end
	
	local bodyCode = block:run_from_port(self, "Loop Body", bodyVisited)
	local completedCode = block:run_from_port(self, "Completed", visited)
	
	local code = `while {cond} do\n`
	code ..= indentCode(bodyCode)
	code ..= "end\n"
	code ..= completedCode
	
	return code
end

return While
