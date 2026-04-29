local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ToolUnequipped = {}
ToolUnequipped.__index = ToolUnequipped
setmetatable(ToolUnequipped, Node)

function ToolUnequipped.new()
	local self = Node.new("Tool Unequipped", NodeType.EVENT)
	setmetatable(self, ToolUnequipped)
	self:editColor(Color3.fromRGB(0, 180, 100))
	
	self:addInput(IO.Input.new("Tool", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function ToolUnequipped:toLuau(block, visited, indentCode)
	local tool = self:getInput("Tool").Value or "nil"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `{tool}.Unequipped:Connect(function()\n` .. indentCode(body) .. "end)\n"
end

return ToolUnequipped
