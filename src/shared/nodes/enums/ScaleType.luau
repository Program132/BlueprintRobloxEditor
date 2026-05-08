local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Types = { "Stretch", "Slice", "Tile", "Fit", "Crop" }

local ScaleTypeNode = {}
ScaleTypeNode.__index = ScaleTypeNode
setmetatable(ScaleTypeNode, Node)

function ScaleTypeNode.new()
	local self = Node.new("Enum ScaleType", NodeType.ENUM)
	setmetatable(self, ScaleTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Stretch", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.ScaleType.Stretch"))
	
	return self
end

function ScaleTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.ScaleType.{selected}`
	return ""
end

return ScaleTypeNode
