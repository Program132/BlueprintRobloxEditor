local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local States = {
	"Default", "Disabled", "Enabled"
}

local RolloutStateNode = {}
RolloutStateNode.__index = RolloutStateNode
setmetatable(RolloutStateNode, Node)

function RolloutStateNode.new()
	local self = Node.new("Enum RolloutState", NodeType.ENUM)
	setmetatable(self, RolloutStateNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("State", "Default", false, States))
	self:addOutput(IO.Output.new("Enum", "Enum.RolloutState.Default"))
	
	return self
end

function RolloutStateNode:toLuau()
	local selected = self:getInput("State").Value
	self:getOutput("Enum").Value = `Enum.RolloutState.{selected}`
	return ""
end

return RolloutStateNode
