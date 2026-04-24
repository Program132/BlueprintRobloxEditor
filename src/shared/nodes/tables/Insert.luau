local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Insert = {}
Insert.__index = Insert
setmetatable(Insert, Node)

function Insert.new()
	local self = Node.new("Table Insert", NodeType.METHOD)
	setmetatable(self, Insert)
	self:editColor(Color3.fromRGB(25, 160, 135))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Table", "{}"))
	self:addInput(IO.Input.new("Value", "nil"))
	self:addInput(IO.Input.new("Pos", "")) -- Optional
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Insert:toLuau()
	local t = self:getInput("Table").Value
	local v = self:getInput("Value").Value
	local p = self:getInput("Pos").Value
	
	if p ~= "" then
		return `table.insert({t}, {p}, {v})\n`
	else
		return `table.insert({t}, {v})\n`
	end
end

return Insert
