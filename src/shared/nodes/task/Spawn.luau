local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Spawn = {}
Spawn.__index = Spawn
setmetatable(Spawn, Node)

function Spawn.new()
	local self = Node.new("Task Spawn", NodeType.CONTROL)
	setmetatable(self, Spawn)
	self:editColor(Color3.fromRGB(200, 100, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Async", "", true))
	
	return self
end

function Spawn:toLuau(block, visited, indentCode)
	local asyncCode = block:run_from_port(self, "Async", visited)
	local nextCode = block:run_from_port(self, "Exec", visited)
	
	local code = "task.spawn(function()\n"
	code ..= indentCode(asyncCode)
	code ..= "end)\n"
	code ..= nextCode
	
	return code
end

return Spawn
