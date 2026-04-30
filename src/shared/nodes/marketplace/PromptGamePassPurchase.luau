local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptGamePassPurchase = {}
PromptGamePassPurchase.__index = PromptGamePassPurchase
setmetatable(PromptGamePassPurchase, Node)

function PromptGamePassPurchase.new()
	local self = Node.new("PromptGamePassPurchase", NodeType.METHOD)
	setmetatable(self, PromptGamePassPurchase)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("GamePassId", "0"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function PromptGamePassPurchase:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local passId = self:getInput("GamePassId").Value or "0"
	return `game:GetService("MarketplaceService"):PromptGamePassPurchase({player}, {passId})\n`
end

return PromptGamePassPurchase
