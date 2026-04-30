local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptPurchaseFinished = {}
PromptPurchaseFinished.__index = PromptPurchaseFinished
setmetatable(PromptPurchaseFinished, Node)

function PromptPurchaseFinished.new()
	local self = Node.new("MarketplaceService PromptPurchaseFinished", NodeType.EVENT)
	setmetatable(self, PromptPurchaseFinished)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("AssetId", "0"))
	self:addOutput(IO.Output.new("IsPurchased", "false"))
	
	return self
end

function PromptPurchaseFinished:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("AssetId").Value = "assetId"
	self:getOutput("IsPurchased").Value = "isPurchased"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return 'game:GetService("MarketplaceService").PromptPurchaseFinished:Connect(function(player, assetId, isPurchased)\n' .. indentCode(body) .. "end)\n"
end

return PromptPurchaseFinished

