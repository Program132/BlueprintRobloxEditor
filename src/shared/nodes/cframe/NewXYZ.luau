local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local NewXYZ = {}
NewXYZ.__index = NewXYZ
setmetatable(NewXYZ, Node)

function NewXYZ.new()
	local self = Node.new("CFrame new XYZ", NodeType.FUNCTION)
	setmetatable(self, NewXYZ)
	self:editColor(Color3.fromRGB(150, 50, 200))

	self:addInput(IO.Input.new("X", "0"))
	self:addInput(IO.Input.new("Y", "0"))
	self:addInput(IO.Input.new("Z", "0"))

	self:addOutput(IO.Output.new("CFrame", "CFrame.new(0, 0, 0)"))

	return self
end

function NewXYZ:toLuau()
	local x = self:getInput("X").Value
	local y = self:getInput("Y").Value
	local z = self:getInput("Z").Value

	self:getOutput("CFrame").Value = `CFrame.new({x}, {y}, {z})`

	return ""
end

return NewXYZ
