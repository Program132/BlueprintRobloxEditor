local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GSub = {}
GSub.__index = GSub
setmetatable(GSub, Node)

function GSub.new()
	local self = Node.new("String GSub", NodeType.FUNCTION)
	setmetatable(self, GSub)
	self:editColor(Color3.fromRGB(180, 70, 70))
	
	self:addInput(IO.Input.new("String", '""'))
	self:addInput(IO.Input.new("Pattern", '""'))
	self:addInput(IO.Input.new("Replacement", '""'))
	self:addInput(IO.Input.new("Max", "")) -- Optional
	
	self:addOutput(IO.Output.new("Result", '""'))
	self:addOutput(IO.Output.new("Count", "0"))
	
	return self
end

function GSub:toLuau()
	local s = self:getInput("String").Value
	local p = self:getInput("Pattern").Value
	local r = self:getInput("Replacement").Value
	local n = self:getInput("Max").Value
	
	local args = `{s}, {p}, {r}`
	if n ~= "" then args = args .. `, {n}` end
	
	local code = `string.gsub({args})`
	self:getOutput("Result").Value = `(select(1, {code}))`
	self:getOutput("Count").Value = `(select(2, {code}))`
	
	return ""
end

return GSub
