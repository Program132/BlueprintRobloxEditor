local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Styles = { "Custom", "ChatBlue", "RobloxSquare", "RobloxRound", "ChatGreen", "ChatRed", "DropShadow" }

local FrameStyleNode = {}
FrameStyleNode.__index = FrameStyleNode
setmetatable(FrameStyleNode, Node)

function FrameStyleNode.new()
	local self = Node.new("Enum FrameStyle", NodeType.ENUM)
	setmetatable(self, FrameStyleNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Style", "Custom", false, Styles))
	self:addOutput(IO.Output.new("Enum", "Enum.FrameStyle.Custom"))
	
	return self
end

function FrameStyleNode:toLuau()
	local selected = self:getInput("Style").Value
	self:getOutput("Enum").Value = `Enum.FrameStyle.{selected}`
	return ""
end

return FrameStyleNode
