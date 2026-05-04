local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local TeleportResults = {
	"Success", "Failure", "GameNotFound", "GameEnded", "GameFull", "Unauthorized", "Flooded", "IsTeleporting"
}

local TeleportResultNode = {}
TeleportResultNode.__index = TeleportResultNode
setmetatable(TeleportResultNode, Node)

function TeleportResultNode.new()
	local self = Node.new("Enum TeleportResult", NodeType.ENUM)
	setmetatable(self, TeleportResultNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Success", false, TeleportResults))
	self:addOutput(IO.Output.new("Enum", "Enum.TeleportResult.Success"))
	
	return self
end

function TeleportResultNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.TeleportResult.{selected}`
	return ""
end

return TeleportResultNode
