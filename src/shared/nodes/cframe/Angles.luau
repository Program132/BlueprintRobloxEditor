local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Angles = {}
Angles.__index = Angles
setmetatable(Angles, Node)

function Angles.new()
	local self = Node.new("CFrame Angles", NodeType.FUNCTION)
	setmetatable(self, Angles)
	self:editColor(Color3.fromRGB(150, 50, 200))

	self:addInput(IO.Input.new("RX", "0"))
	self:addInput(IO.Input.new("RY", "0"))
	self:addInput(IO.Input.new("RZ", "0"))

	self:addOutput(IO.Output.new("CFrame", "CFrame.Angles(0, 0, 0)"))

	return self
end

function Angles:toLuau()
	local rx = self:getInput("RX").Value
	local ry = self:getInput("RY").Value
	local rz = self:getInput("RZ").Value

	self:getOutput("CFrame").Value = `CFrame.Angles({rx}, {ry}, {rz})`

	return ""
end

return Angles
