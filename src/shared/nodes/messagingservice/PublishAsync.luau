local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PublishAsync = {}
PublishAsync.__index = PublishAsync
setmetatable(PublishAsync, Node)

function PublishAsync.new()
	local self = Node.new("Messaging PublishAsync", NodeType.METHOD)
	setmetatable(self, PublishAsync)
	self:editColor(Color3.fromRGB(255, 150, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addOutput(IO.Output.new("Exec", ""))
	
	self:addInput(IO.Input.new("Topic", "''"))
	self:addInput(IO.Input.new("Message", "nil"))
	
	return self
end

function PublishAsync:toLuau()
	local topic = self:getInput("Topic").Value or "''"
	local message = self:getInput("Message").Value or "nil"
	return `game:GetService("MessagingService"):PublishAsync({topic}, {message})\n`
end

return PublishAsync
