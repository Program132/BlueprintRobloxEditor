local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Sort = {}
Sort.__index = Sort
setmetatable(Sort, Node)

function Sort.new()
	local self = Node.new("Table Sort", NodeType.METHOD)
	setmetatable(self, Sort)
	self:editColor(Color3.fromRGB(25, 160, 135))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Table", "{}"))
	-- Callback would be hard to implement now without a way to pass a function reference
	-- For now, default sorting
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Sort:toLuau()
	local t = self:getInput("Table").Value
	return `table.sort({t})\n`
end

return Sort
