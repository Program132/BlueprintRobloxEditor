local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Defer = {}
Defer.__index = Defer
setmetatable(Defer, Node)

function Defer.new()
	local self = Node.new("Task Defer", NodeType.CONTROL)
	setmetatable(self, Defer)
	self:editColor(Color3.fromRGB(200, 100, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Async", "", true))
	
	return self
end

function Defer:toLuau(block, visited, indentCode)
	local asyncCode = block:run_from_port(self, "Async", visited)
	local nextCode = block:run_from_port(self, "Exec", visited)
	
	local code = "task.defer(function()\n"
	code ..= indentCode(asyncCode)
	code ..= "end)\n"
	code ..= nextCode
	
	return code
end

return Defer
