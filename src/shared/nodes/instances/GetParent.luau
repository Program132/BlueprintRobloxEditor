local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetParent = {}
GetParent.__index = GetParent
setmetatable(GetParent, Node)

function GetParent.new()
	local self = Node.new("Get Parent", NodeType.FUNCTION)
	setmetatable(self, GetParent)
	self:editColor(Color3.fromRGB(100, 180, 255))

	self:addInput(IO.Input.new("Instance", "workspace"))
	self:addOutput(IO.Output.new("Parent", "nil"))

	return self
end

function GetParent:toLuau()
	local inst = self:getInput("Instance").Value
	self:getOutput("Parent").Value = `{inst}.Parent`
	return ""
end

return GetParent
