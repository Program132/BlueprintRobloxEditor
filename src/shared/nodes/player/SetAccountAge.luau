local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SetAccountAge = {}
SetAccountAge.__index = SetAccountAge
setmetatable(SetAccountAge, Node)

function SetAccountAge.new()
	local self = Node.new("Player SetAccountAge", NodeType.METHOD)
	setmetatable(self, SetAccountAge)
	self:editTitle("Set Account Age")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Age", "0"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SetAccountAge:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local age = self:getInput("Age").Value or "0"
	return `{inst}:SetAccountAge({age})\n`
end

return SetAccountAge
