local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptProductPurchaseFinished = {}
PromptProductPurchaseFinished.__index = PromptProductPurchaseFinished
setmetatable(PromptProductPurchaseFinished, Node)

function PromptProductPurchaseFinished.new()
	local self = Node.new("MarketplaceService PromptProductPurchaseFinished", NodeType.EVENT)
	setmetatable(self, PromptProductPurchaseFinished)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("UserId", "0"))
	self:addOutput(IO.Output.new("ProductId", "0"))
	self:addOutput(IO.Output.new("IsPurchased", "false"))
	
	return self
end

function PromptProductPurchaseFinished:toLuau(block, visited, indentCode)
	self:getOutput("UserId").Value = "userId"
	self:getOutput("ProductId").Value = "productId"
	self:getOutput("IsPurchased").Value = "isPurchased"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return 'game:GetService("MarketplaceService").PromptProductPurchaseFinished:Connect(function(userId, productId, isPurchased)\n' .. indentCode(body) .. "end)\n"
end

return PromptProductPurchaseFinished

