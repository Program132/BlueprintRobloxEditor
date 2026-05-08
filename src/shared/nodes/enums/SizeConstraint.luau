local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Constraints = { "RelativeXY", "RelativeXX", "RelativeYY" }

local SizeConstraintNode = {}
SizeConstraintNode.__index = SizeConstraintNode
setmetatable(SizeConstraintNode, Node)

function SizeConstraintNode.new()
	local self = Node.new("Enum SizeConstraint", NodeType.ENUM)
	setmetatable(self, SizeConstraintNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Constraint", "RelativeXY", false, Constraints))
	self:addOutput(IO.Output.new("Enum", "Enum.SizeConstraint.RelativeXY"))
	
	return self
end

function SizeConstraintNode:toLuau()
	local selected = self:getInput("Constraint").Value
	self:getOutput("Enum").Value = `Enum.SizeConstraint.{selected}`
	return ""
end

return SizeConstraintNode
