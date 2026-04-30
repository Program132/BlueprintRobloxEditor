local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptBundlePurchaseFinished = {}
PromptBundlePurchaseFinished.__index = PromptBundlePurchaseFinished
setmetatable(PromptBundlePurchaseFinished, Node)

function PromptBundlePurchaseFinished.new()
	local self = Node.new("MarketplaceService PromptBundlePurchaseFinished", NodeType.EVENT)
	setmetatable(self, PromptBundlePurchaseFinished)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("BundleId", "0"))
	self:addOutput(IO.Output.new("WasPurchased", "false"))
	
	return self
end

function PromptBundlePurchaseFinished:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("BundleId").Value = "bundleId"
	self:getOutput("WasPurchased").Value = "wasPurchased"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return 'game:GetService("MarketplaceService").PromptBundlePurchaseFinished:Connect(function(player, bundleId, wasPurchased)\n' .. indentCode(body) .. "end)\n"
end

return PromptBundlePurchaseFinished

