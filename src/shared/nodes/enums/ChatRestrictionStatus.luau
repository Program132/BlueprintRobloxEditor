local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Statuses = {
	"Unknown", "NotRestricted", "Restricted"
}

local ChatRestrictionStatusNode = {}
ChatRestrictionStatusNode.__index = ChatRestrictionStatusNode
setmetatable(ChatRestrictionStatusNode, Node)

function ChatRestrictionStatusNode.new()
	local self = Node.new("Enum ChatRestrictionStatus", NodeType.ENUM)
	setmetatable(self, ChatRestrictionStatusNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Status", "NotRestricted", false, Statuses))
	self:addOutput(IO.Output.new("Enum", "Enum.ChatRestrictionStatus.NotRestricted"))
	
	return self
end

function ChatRestrictionStatusNode:toLuau()
	local selected = self:getInput("Status").Value
	self:getOutput("Enum").Value = `Enum.ChatRestrictionStatus.{selected}`
	return ""
end

return ChatRestrictionStatusNode
