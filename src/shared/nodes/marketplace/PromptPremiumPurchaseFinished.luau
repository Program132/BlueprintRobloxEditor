local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptPremiumPurchaseFinished = {}
PromptPremiumPurchaseFinished.__index = PromptPremiumPurchaseFinished
setmetatable(PromptPremiumPurchaseFinished, Node)

function PromptPremiumPurchaseFinished.new()
	local self = Node.new("Marketplace PromptPremiumPurchaseFinished", NodeType.EVENT)
	setmetatable(self, PromptPremiumPurchaseFinished)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptPremiumPurchaseFinished:toLuau(block, visited, indentCode)
	local body = block:run_from_port(self, "Exec", visited)
	
	return 'game:GetService("MarketplaceService").PromptPremiumPurchaseFinished:Connect(function()\n' .. indentCode(body) .. "end)\n"
end

return PromptPremiumPurchaseFinished
