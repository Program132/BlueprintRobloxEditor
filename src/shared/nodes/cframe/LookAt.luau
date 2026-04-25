local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local LookAt = {}
LookAt.__index = LookAt
setmetatable(LookAt, Node)

function LookAt.new()
	local self = Node.new("CFrame lookAt", NodeType.FUNCTION)
	setmetatable(self, LookAt)
	self:editColor(Color3.fromRGB(150, 50, 200))

	self:addInput(IO.Input.new("At", "Vector3.zero"))
	self:addInput(IO.Input.new("LookAt", "Vector3.new(0, 0, -1)"))
	self:addInput(IO.Input.new("Up", "Vector3.yAxis"))

	self:addOutput(IO.Output.new("CFrame", "CFrame.lookAt(Vector3.zero, Vector3.new(0,0,-1))"))

	return self
end

function LookAt:toLuau()
	local at = self:getInput("At").Value
	local lookAt = self:getInput("LookAt").Value
	local up = self:getInput("Up").Value

	self:getOutput("CFrame").Value = `CFrame.lookAt({at}, {lookAt}, {up})`

	return ""
end

return LookAt
