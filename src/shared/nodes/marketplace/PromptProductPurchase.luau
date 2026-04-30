local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptProductPurchase = {}
PromptProductPurchase.__index = PromptProductPurchase
setmetatable(PromptProductPurchase, Node)

function PromptProductPurchase.new()
	local self = Node.new("MarketplaceService PromptProductPurchase", NodeType.METHOD)
	setmetatable(self, PromptProductPurchase)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("ProductId", "0"))
	self:addInput(IO.Input.new("EquipIfPurchased", "false"))
	self:addInput(IO.Input.new("CurrencyType", "Enum.CurrencyType.Robux"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptProductPurchase:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local prodId = self:getInput("ProductId").Value or "0"
	local equip = self:getInput("EquipIfPurchased").Value or "false"
	local currency = self:getInput("CurrencyType").Value or "Enum.CurrencyType.Robux"
	return `game:GetService("MarketplaceService"):PromptProductPurchase({player}, {prodId}, {equip}, {currency})\n`
end

return PromptProductPurchase

