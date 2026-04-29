local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ToNumber = {}
ToNumber.__index = ToNumber
setmetatable(ToNumber, Node)

function ToNumber.new()
	local self = Node.new("ToNumber", NodeType.FUNCTION)
	setmetatable(self, ToNumber)
	self:editColor(Color3.fromRGB(40, 150, 70)) -- Math color

	self:addInput(IO.Input.new("Value", '""'))
	self:addOutput(IO.Output.new("Number", "0"))

	return self
end

function ToNumber:toLuau()
	local val = self:getInput("Value").Value or '""'
	self:getOutput("Number").Value = `tonumber({val})`
	return ""
end

return ToNumber
