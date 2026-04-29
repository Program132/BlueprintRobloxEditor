local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ToolEquipped = {}
ToolEquipped.__index = ToolEquipped
setmetatable(ToolEquipped, Node)

function ToolEquipped.new()
	local self = Node.new("Tool Equipped", NodeType.EVENT)
	setmetatable(self, ToolEquipped)
	self:editColor(Color3.fromRGB(0, 180, 100))
	
	self:addInput(IO.Input.new("Tool", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Mouse", "nil"))
	
	return self
end

function ToolEquipped:toLuau(block, visited, indentCode)
	local tool = self:getInput("Tool").Value or "nil"
	self:getOutput("Mouse").Value = "mouse"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `{tool}.Equipped:Connect(function(mouse)\n` .. indentCode(body) .. "end)\n"
end

return ToolEquipped
