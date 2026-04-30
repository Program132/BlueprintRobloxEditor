local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptSubscriptionPurchase = {}
PromptSubscriptionPurchase.__index = PromptSubscriptionPurchase
setmetatable(PromptSubscriptionPurchase, Node)

function PromptSubscriptionPurchase.new()
	local self = Node.new("PromptSubscriptionPurchase", NodeType.METHOD)
	setmetatable(self, PromptSubscriptionPurchase)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("User", "nil"))
	self:addInput(IO.Input.new("SubscriptionId", "''"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptSubscriptionPurchase:toLuau()
	local user = self:getInput("User").Value or "nil"
	local subId = self:getInput("SubscriptionId").Value or "''"
	return `game:GetService("MarketplaceService"):PromptSubscriptionPurchase({user}, {subId})\n`
end

return PromptSubscriptionPurchase
