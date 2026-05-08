local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local States = { "Idle", "Hover", "Press", "NonInteractable" }

local GuiStateNode = {}
GuiStateNode.__index = GuiStateNode
setmetatable(GuiStateNode, Node)

function GuiStateNode.new()
	local self = Node.new("Enum GuiState", NodeType.ENUM)
	setmetatable(self, GuiStateNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("State", "Idle", false, States))
	self:addOutput(IO.Output.new("Enum", "Enum.GuiState.Idle"))
	
	return self
end

function GuiStateNode:toLuau()
	local selected = self:getInput("State").Value
	self:getOutput("Enum").Value = `Enum.GuiState.{selected}`
	return ""
end

return GuiStateNode
