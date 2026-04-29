local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ToolActivated = {}
ToolActivated.__index = ToolActivated
setmetatable(ToolActivated, Node)

function ToolActivated.new()
	local self = Node.new("Tool Activated", NodeType.EVENT)
	setmetatable(self, ToolActivated)
	self:editColor(Color3.fromRGB(0, 180, 100))
	
	self:addInput(IO.Input.new("Tool", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function ToolActivated:toLuau(block, visited, indentCode)
	local tool = self:getInput("Tool").Value or "nil"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `{tool}.Activated:Connect(function()\n` .. indentCode(body) .. "end)\n"
end

return ToolActivated
