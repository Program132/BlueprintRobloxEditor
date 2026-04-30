local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptRobloxSubscriptionPurchaseFinished = {}
PromptRobloxSubscriptionPurchaseFinished.__index = PromptRobloxSubscriptionPurchaseFinished
setmetatable(PromptRobloxSubscriptionPurchaseFinished, Node)

function PromptRobloxSubscriptionPurchaseFinished.new()
	local self = Node.new("Marketplace PromptRobloxSubscriptionPurchaseFinished", NodeType.EVENT)
	setmetatable(self, PromptRobloxSubscriptionPurchaseFinished)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("User", "nil"))
	self:addOutput(IO.Output.new("DidTryPurchasing", "false"))
	
	return self
end

function PromptRobloxSubscriptionPurchaseFinished:toLuau(block, visited, indentCode)
	self:getOutput("User").Value = "user"
	self:getOutput("DidTryPurchasing").Value = "didTryPurchasing"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return 'game:GetService("MarketplaceService").PromptRobloxSubscriptionPurchaseFinished:Connect(function(user, didTryPurchasing)\n' .. indentCode(body) .. "end)\n"
end

return PromptRobloxSubscriptionPurchaseFinished
