local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptPurchase = {}
PromptPurchase.__index = PromptPurchase
setmetatable(PromptPurchase, Node)

function PromptPurchase.new()
	local self = Node.new("MarketplaceService PromptPurchase", NodeType.METHOD)
	setmetatable(self, PromptPurchase)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("AssetId", "0"))
	self:addInput(IO.Input.new("EquipIfPurchased", "false"))
	self:addInput(IO.Input.new("CurrencyType", "Enum.CurrencyType.Robux"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptPurchase:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local assetId = self:getInput("AssetId").Value or "0"
	local equip = self:getInput("EquipIfPurchased").Value or "false"
	local currency = self:getInput("CurrencyType").Value or "Enum.CurrencyType.Robux"
	return `game:GetService("MarketplaceService"):PromptPurchase({player}, {assetId}, {equip}, {currency})\n`
end

return PromptPurchase

