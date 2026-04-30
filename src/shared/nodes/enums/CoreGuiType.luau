local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local CoreGuiTypes = {
	"PlayerList", "Health", "Backpack", "Chat", "All", "EmotesMenu", "SelfView", "Captures", "AvatarSwitcher"
}

local CoreGuiTypeNode = {}
CoreGuiTypeNode.__index = CoreGuiTypeNode
setmetatable(CoreGuiTypeNode, Node)

function CoreGuiTypeNode.new()
	local self = Node.new("Enum CoreGuiType", NodeType.ENUM)
	setmetatable(self, CoreGuiTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "All", false, CoreGuiTypes))
	self:addOutput(IO.Output.new("Enum", "Enum.CoreGuiType.All"))
	
	return self
end

function CoreGuiTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.CoreGuiType.{selected}`
	return ""
end

return CoreGuiTypeNode
