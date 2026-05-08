local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Insets = { "None", "ScrollBar", "Always" }

local ScrollBarInsetNode = {}
ScrollBarInsetNode.__index = ScrollBarInsetNode
setmetatable(ScrollBarInsetNode, Node)

function ScrollBarInsetNode.new()
	local self = Node.new("Enum ScrollBarInset", NodeType.ENUM)
	setmetatable(self, ScrollBarInsetNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Inset", "None", false, Insets))
	self:addOutput(IO.Output.new("Enum", "Enum.ScrollBarInset.None"))
	
	return self
end

function ScrollBarInsetNode:toLuau()
	local selected = self:getInput("Inset").Value
	self:getOutput("Enum").Value = `Enum.ScrollBarInset.{selected}`
	return ""
end

return ScrollBarInsetNode
