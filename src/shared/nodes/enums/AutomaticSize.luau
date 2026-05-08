local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Options = { "None", "X", "Y", "XY" }

local AutomaticSizeNode = {}
AutomaticSizeNode.__index = AutomaticSizeNode
setmetatable(AutomaticSizeNode, Node)

function AutomaticSizeNode.new()
	local self = Node.new("Enum AutomaticSize", NodeType.ENUM)
	setmetatable(self, AutomaticSizeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Size", "None", false, Options))
	self:addOutput(IO.Output.new("Enum", "Enum.AutomaticSize.None"))
	
	return self
end

function AutomaticSizeNode:toLuau()
	local selected = self:getInput("Size").Value
	self:getOutput("Enum").Value = `Enum.AutomaticSize.{selected}`
	return ""
end

return AutomaticSizeNode
