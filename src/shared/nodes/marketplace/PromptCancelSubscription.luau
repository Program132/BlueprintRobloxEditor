local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptCancelSubscription = {}
PromptCancelSubscription.__index = PromptCancelSubscription
setmetatable(PromptCancelSubscription, Node)

function PromptCancelSubscription.new()
	local self = Node.new("PromptCancelSubscription", NodeType.METHOD)
	setmetatable(self, PromptCancelSubscription)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("User", "nil"))
	self:addInput(IO.Input.new("SubscriptionId", "''"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptCancelSubscription:toLuau()
	local user = self:getInput("User").Value or "nil"
	local subId = self:getInput("SubscriptionId").Value or "''"
	return `game:GetService("MarketplaceService"):PromptCancelSubscription({user}, {subId})\n`
end

return PromptCancelSubscription
