local Node = require(script.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.IO)

local Return = {}
Return.__index = Return
setmetatable(Return, Node) 

function Return.new()
	local self = Node.new("Return", NodeType.METHOD)
	setmetatable(self, Return)
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Value", ""))
	
	return self
end

function Return:toLuau()
	local valInput = self:getInput("Value")
	local val = valInput and valInput.Value or ""
	
	if val ~= "" then
		return "return " .. val .. "\n"
	else
		return "return\n"
	end
end

return Return
