local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local States = {
	"Stopped", "Running", "Paused"
}

local RunStateNode = {}
RunStateNode.__index = RunStateNode
setmetatable(RunStateNode, Node)

function RunStateNode.new()
	local self = Node.new("Enum RunState", NodeType.ENUM)
	setmetatable(self, RunStateNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("State", "Running", false, States))
	self:addOutput(IO.Output.new("Enum", "Enum.RunState.Running"))
	
	return self
end

function RunStateNode:toLuau()
	local selected = self:getInput("State").Value
	self:getOutput("Enum").Value = `Enum.RunState.{selected}`
	return ""
end

return RunStateNode
