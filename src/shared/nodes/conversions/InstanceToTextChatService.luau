local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local InstanceToTextChatServiceNode = {}
InstanceToTextChatServiceNode.__index = InstanceToTextChatServiceNode
setmetatable(InstanceToTextChatServiceNode, Node)

function InstanceToTextChatServiceNode.new()
	local self = Node.new("Instance to TextChatService", NodeType.FUNCTION)
	setmetatable(self, InstanceToTextChatServiceNode)
	self:editColor(Color3.fromRGB(200, 50, 255))
	
	self:addInput(IO.Input.new("Instance", "nil"))
	
	-- Custom properties
	self:addOutput(IO.Output.new("ChatTranslationEnabled", "false"))
	self:addOutput(IO.Output.new("CreateDefaultCommands", "true"))
	self:addOutput(IO.Output.new("CreateDefaultTextChannels", "true"))
	
	-- Base instance properties
	self:addOutput(IO.Output.new("Archivable", "true"))
	self:addOutput(IO.Output.new("Capabilities", "nil"))
	self:addOutput(IO.Output.new("Name", "''"))
	self:addOutput(IO.Output.new("Parent", "nil"))
	self:addOutput(IO.Output.new("PredictionMode", "Enum.PredictionMode.Default"))
	self:addOutput(IO.Output.new("Sandboxed", "false"))
	self:addOutput(IO.Output.new("UniqueId", "''"))
	
	return self
end

function InstanceToTextChatServiceNode:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	
	self:getOutput("ChatTranslationEnabled").Value = `{inst}.ChatTranslationEnabled`
	self:getOutput("CreateDefaultCommands").Value = `{inst}.CreateDefaultCommands`
	self:getOutput("CreateDefaultTextChannels").Value = `{inst}.CreateDefaultTextChannels`
	
	self:getOutput("Archivable").Value = `{inst}.Archivable`
	self:getOutput("Capabilities").Value = `{inst}.Capabilities`
	self:getOutput("Name").Value = `{inst}.Name`
	self:getOutput("Parent").Value = `{inst}.Parent`
	self:getOutput("PredictionMode").Value = `{inst}.PredictionMode`
	self:getOutput("Sandboxed").Value = `{inst}.Sandboxed`
	self:getOutput("UniqueId").Value = `{inst}.UniqueId`
	
	return ""
end

return InstanceToTextChatServiceNode
