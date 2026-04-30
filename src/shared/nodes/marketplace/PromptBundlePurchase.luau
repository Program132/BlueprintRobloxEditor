local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptBundlePurchase = {}
PromptBundlePurchase.__index = PromptBundlePurchase
setmetatable(PromptBundlePurchase, Node)

function PromptBundlePurchase.new()
	local self = Node.new("PromptBundlePurchase", NodeType.METHOD)
	setmetatable(self, PromptBundlePurchase)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("BundleId", "0"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptBundlePurchase:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local bundleId = self:getInput("BundleId").Value or "0"
	return `game:GetService("MarketplaceService"):PromptBundlePurchase({player}, {bundleId})\n`
end

return PromptBundlePurchase
