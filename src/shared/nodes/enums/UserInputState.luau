local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local States = {
	"Begin", "Change", "End", "Cancel", "None"
}

local UserInputStateNode = {}
UserInputStateNode.__index = UserInputStateNode
setmetatable(UserInputStateNode, Node)

function UserInputStateNode.new()
	local self = Node.new("Enum UserInputState", NodeType.ENUM)
	setmetatable(self, UserInputStateNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("State", "Begin", false, States))
	self:addOutput(IO.Output.new("Enum", "Enum.UserInputState.Begin"))
	
	return self
end

function UserInputStateNode:toLuau()
	local selected = self:getInput("State").Value
	self:getOutput("Enum").Value = `Enum.UserInputState.{selected}`
	return ""
end

return UserInputStateNode
