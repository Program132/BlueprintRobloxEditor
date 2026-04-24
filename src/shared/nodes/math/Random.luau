local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Random = {}
Random.__index = Random
setmetatable(Random, Node)

function Random.new()
	local self = Node.new("Random", NodeType.FUNCTION)
	setmetatable(self, Random)
	self:editColor(Color3.fromRGB(40, 150, 70))
	self:addInput(IO.Input.new("Min", ""))
	self:addInput(IO.Input.new("Max", ""))
	self:addOutput(IO.Output.new("Result", "0"))
	return self
end

function Random:toLuau()
	local min = self:getInput("Min").Value
	local max = self:getInput("Max").Value
	
	local args = ""
	if min ~= "" and max ~= "" then
		args = `{min}, {max}`
	elseif min ~= "" then
		args = `{min}`
	end
	
	self:getOutput("Result").Value = `math.random({args})`
	return ""
end

return Random
