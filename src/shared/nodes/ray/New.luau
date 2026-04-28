local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local New = {}
New.__index = New
setmetatable(New, Node)

function New.new()
	local self = Node.new("Ray new", NodeType.FUNCTION)
	setmetatable(self, New)
	self:editColor(Color3.fromRGB(120, 80, 220))

	self:addInput(IO.Input.new("Origin", ""))
	self:addInput(IO.Input.new("Direction", ""))

	self:addOutput(IO.Output.new("Ray", "Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0))"))
	self:addOutput(IO.Output.new("Unit", "Ray.new(Vector3.new(0, 0, 0), Vector3.new(0, 0, 0))"))
	self:addOutput(IO.Output.new("Origin", "Vector3.new(0, 0, 0)"))
	self:addOutput(IO.Output.new("Direction", "Vector3.new(0, 0, 0)"))

	return self
end

function New:toLuau()
	local origin = self:getInput("Origin").Value
	local direction = self:getInput("Direction").Value

	local base = `Ray.new({origin}, {direction})`
	
	self:getOutput("Ray").Value = base
	self:getOutput("Unit").Value = `{base}.Unit`
	self:getOutput("Origin").Value = `{base}.Origin`
	self:getOutput("Direction").Value = `{base}.Direction`

	return ""
end

return New
