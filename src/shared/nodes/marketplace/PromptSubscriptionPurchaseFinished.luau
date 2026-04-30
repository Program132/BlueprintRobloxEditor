local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptSubscriptionPurchaseFinished = {}
PromptSubscriptionPurchaseFinished.__index = PromptSubscriptionPurchaseFinished
setmetatable(PromptSubscriptionPurchaseFinished, Node)

function PromptSubscriptionPurchaseFinished.new()
	local self = Node.new("MarketplaceService PromptSubscriptionPurchaseFinished", NodeType.EVENT)
	setmetatable(self, PromptSubscriptionPurchaseFinished)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("User", "nil"))
	self:addOutput(IO.Output.new("SubscriptionId", "''"))
	self:addOutput(IO.Output.new("DidTryPurchasing", "false"))
	
	return self
end

function PromptSubscriptionPurchaseFinished:toLuau(block, visited, indentCode)
	self:getOutput("User").Value = "user"
	self:getOutput("SubscriptionId").Value = "subscriptionId"
	self:getOutput("DidTryPurchasing").Value = "didTryPurchasing"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return 'game:GetService("MarketplaceService").PromptSubscriptionPurchaseFinished:Connect(function(user, subscriptionId, didTryPurchasing)\n' .. indentCode(body) .. "end)\n"
end

return PromptSubscriptionPurchaseFinished

