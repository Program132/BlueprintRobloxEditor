local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SubscribeAsync = {}
SubscribeAsync.__index = SubscribeAsync
setmetatable(SubscribeAsync, Node)

function SubscribeAsync.new()
	local self = Node.new("Messaging SubscribeAsync", NodeType.EVENT)
	setmetatable(self, SubscribeAsync)
	self:editColor(Color3.fromRGB(255, 150, 50))
	
	self:addInput(IO.Input.new("Topic", "''"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Data", "nil"))
	self:addOutput(IO.Output.new("Sent", "0"))
	
	return self
end

function SubscribeAsync:toLuau()
	local topic = self:getInput("Topic").Value or "''"
	self:getOutput("Data").Value = "messageData.Data"
	self:getOutput("Sent").Value = "messageData.Sent"
	
	return `game:GetService("MessagingService"):SubscribeAsync({topic}, function(messageData)\n`, "\nend)"
end

return SubscribeAsync
