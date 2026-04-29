local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ToString = {}
ToString.__index = ToString
setmetatable(ToString, Node)

function ToString.new()
	local self = Node.new("ToString", NodeType.FUNCTION)
	setmetatable(self, ToString)
	self:editColor(Color3.fromRGB(180, 70, 70)) -- String color

	self:addInput(IO.Input.new("Value", "nil"))
	self:addOutput(IO.Output.new("String", '""'))

	return self
end

function ToString:toLuau()
	local val = self:getInput("Value").Value or "nil"
	self:getOutput("String").Value = `tostring({val})`
	return ""
end

return ToString
