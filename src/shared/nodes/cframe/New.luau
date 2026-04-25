local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local New = {}
New.__index = New
setmetatable(New, Node)

function New.new()
	local self = Node.new("CFrame new", NodeType.FUNCTION)
	setmetatable(self, New)
	self:editColor(Color3.fromRGB(150, 50, 200))

	self:addInput(IO.Input.new("Position", "Vector3.zero"))

	self:addOutput(IO.Output.new("CFrame", "CFrame.new()"))
	self:addOutput(IO.Output.new("Position", "Vector3.zero"))
	self:addOutput(IO.Output.new("Rotation", "CFrame.identity"))
	self:addOutput(IO.Output.new("LookVector", "Vector3.new(0, 0, -1)"))
	self:addOutput(IO.Output.new("RightVector", "Vector3.new(1, 0, 0)"))
	self:addOutput(IO.Output.new("UpVector", "Vector3.new(0, 1, 0)"))

	return self
end

function New:toLuau()
	local pos = self:getInput("Position").Value

	local base = `CFrame.new({pos})`
	
	self:getOutput("CFrame").Value = base
	self:getOutput("Position").Value = `{base}.Position`
	self:getOutput("Rotation").Value = `{base}.Rotation`
	self:getOutput("LookVector").Value = `{base}.LookVector`
	self:getOutput("RightVector").Value = `{base}.RightVector`
	self:getOutput("UpVector").Value = `{base}.UpVector`

	return ""
end

return New
