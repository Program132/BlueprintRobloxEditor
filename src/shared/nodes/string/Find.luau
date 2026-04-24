local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Find = {}
Find.__index = Find
setmetatable(Find, Node)

function Find.new()
	local self = Node.new("String Find", NodeType.FUNCTION)
	setmetatable(self, Find)
	self:editColor(Color3.fromRGB(180, 70, 70))
	
	self:addInput(IO.Input.new("String", '""'))
	self:addInput(IO.Input.new("Pattern", '""'))
	self:addInput(IO.Input.new("Init", "1"))
	self:addInput(IO.Input.new("Plain", "false"))
	
	self:addOutput(IO.Output.new("Start", "nil"))
	self:addOutput(IO.Output.new("End", "nil"))
	
	return self
end

function Find:toLuau()
	local s = self:getInput("String").Value
	local p = self:getInput("Pattern").Value
	local i = self:getInput("Init").Value
	local pl = self:getInput("Plain").Value
	
	local code = `string.find({s}, {p}, {i}, {pl})`
	self:getOutput("Start").Value = `(select(1, {code}))`
	self:getOutput("End").Value = `(select(2, {code}))`
	
	return ""
end

return Find
