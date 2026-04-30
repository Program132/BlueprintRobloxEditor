local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptRobloxSubscriptionPurchase = {}
PromptRobloxSubscriptionPurchase.__index = PromptRobloxSubscriptionPurchase
setmetatable(PromptRobloxSubscriptionPurchase, Node)

function PromptRobloxSubscriptionPurchase.new()
	local self = Node.new("MarketplaceService PromptRobloxSubscriptionPurchase", NodeType.METHOD)
	setmetatable(self, PromptRobloxSubscriptionPurchase)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("User", "nil"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptRobloxSubscriptionPurchase:toLuau()
	local user = self:getInput("User").Value or "nil"
	return `game:GetService("MarketplaceService"):PromptRobloxSubscriptionPurchase({user})\n`
end

return PromptRobloxSubscriptionPurchase

