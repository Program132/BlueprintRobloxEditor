local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Delay = {}
Delay.__index = Delay
setmetatable(Delay, Node)

function Delay.new()
	local self = Node.new("Task Delay", NodeType.CONTROL)
	setmetatable(self, Delay)
	self:editColor(Color3.fromRGB(200, 100, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Duration", "0"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Async", "", true))
	
	return self
end

function Delay:toLuau(block, visited, indentCode)
	local duration = self:getInput("Duration").Value
	local asyncCode = block:run_from_port(self, "Async", visited)
	local nextCode = block:run_from_port(self, "Exec", visited)
	
	local code = `task.delay({duration}, function()\n`
	code ..= indentCode(asyncCode)
	code ..= "end)\n"
	code ..= nextCode
	
	return code
end

return Delay
