local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptBulkPurchase = {}
PromptBulkPurchase.__index = PromptBulkPurchase
setmetatable(PromptBulkPurchase, Node)

function PromptBulkPurchase.new()
	local self = Node.new("PromptBulkPurchase", NodeType.METHOD)
	setmetatable(self, PromptBulkPurchase)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("LineItems", "{}"))
	self:addInput(IO.Input.new("Options", "{}"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptBulkPurchase:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local items = self:getInput("LineItems").Value or "{}"
	local options = self:getInput("Options").Value or "{}"
	return `game:GetService("MarketplaceService"):PromptBulkPurchase({player}, {items}, {options})\n`
end

return PromptBulkPurchase
