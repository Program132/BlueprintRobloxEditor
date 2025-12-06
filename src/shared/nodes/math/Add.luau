local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Add = {}
Add.__index = Add
setmetatable(Add, Node)

function Add.new()
	local self = Node.new("Add", NodeType.FUNCTION)
	setmetatable(self, Add)

	self:addInput(IO.Input.new("A", "0"))
	self:addInput(IO.Input.new("B", "0"))
	self:addOutput(IO.Output.new("Result", "0"))

	return self
end

function Add:toLuau()
	local a = self:getInput("A")
	local b = self:getInput("B")
	local valA = a and a.Value or "0"
	local valB = b and b.Value or "0"
	
	-- Store the expression in the output (not the calculated result)
	local resultOutput = self:getOutput("Result")
	if resultOutput then
		resultOutput.Value = "("..valA .. " + " .. valB..")"
	end
	
	-- Return empty string - Add node doesn't generate visible code
	-- The expression is transferred via data edges
	return ""
end

return Add
