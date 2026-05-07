local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Statuses = {
	"None", "Joined", "JoinRequestPending", "AlreadyMember"
}

local GroupMembershipStatusNode = {}
GroupMembershipStatusNode.__index = GroupMembershipStatusNode
setmetatable(GroupMembershipStatusNode, Node)

function GroupMembershipStatusNode.new()
	local self = Node.new("Enum GroupMembershipStatus", NodeType.ENUM)
	setmetatable(self, GroupMembershipStatusNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Status", "None", false, Statuses))
	self:addOutput(IO.Output.new("Enum", "Enum.GroupMembershipStatus.None"))
	
	return self
end

function GroupMembershipStatusNode:toLuau()
	local selected = self:getInput("Status").Value
	self:getOutput("Enum").Value = `Enum.GroupMembershipStatus.{selected}`
	return ""
end

return GroupMembershipStatusNode
