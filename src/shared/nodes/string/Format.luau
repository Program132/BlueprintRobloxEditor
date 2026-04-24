local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Format = {}
Format.__index = Format
setmetatable(Format, Node)

function Format.new()
	local self = Node.new("String Format", NodeType.FUNCTION)
	setmetatable(self, Format)
	self:editColor(Color3.fromRGB(180, 70, 70))
	
	self:addInput(IO.Input.new("Format", '"%s"'))
	self:addInput(IO.Input.new("Arg 1", ""))
	self:addInput(IO.Input.new("Arg 2", ""))
	self:addInput(IO.Input.new("Arg 3", ""))
	
	self:addOutput(IO.Output.new("Result", '""'))
	
	return self
end

function Format:toLuau()
	local fmt = self:getInput("Format").Value
	local a1 = self:getInput("Arg 1").Value
	local a2 = self:getInput("Arg 2").Value
	local a3 = self:getInput("Arg 3").Value
	
	local args = {fmt}
	if a1 ~= "" then table.insert(args, a1) end
	if a2 ~= "" then table.insert(args, a2) end
	if a3 ~= "" then table.insert(args, a3) end
	
	local argsStr = table.concat(args, ", ")
	self:getOutput("Result").Value = `string.format({argsStr})`
	
	return ""
end

return Format
