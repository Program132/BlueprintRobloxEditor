local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Remove = {}
Remove.__index = Remove
setmetatable(Remove, Node)

function Remove.new()
	local self = Node.new("Table Remove", NodeType.METHOD)
	setmetatable(self, Remove)
	self:editColor(Color3.fromRGB(25, 160, 135))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Table", "{}"))
	self:addInput(IO.Input.new("Pos", "")) -- Optional
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Removed Value", "nil"))
	
	return self
end

function Remove:toLuau()
	local t = self:getInput("Table").Value
	local p = self:getInput("Pos").Value
	
	local call = `table.remove({t}{p ~= "" and ", " .. p or ""})`
	self:getOutput("Removed Value").Value = call
	return call .. "\n"
end

return Remove
