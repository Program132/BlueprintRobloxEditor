local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptGamePassPurchaseFinished = {}
PromptGamePassPurchaseFinished.__index = PromptGamePassPurchaseFinished
setmetatable(PromptGamePassPurchaseFinished, Node)

function PromptGamePassPurchaseFinished.new()
	local self = Node.new("Marketplace PromptGamePassPurchaseFinished", NodeType.EVENT)
	setmetatable(self, PromptGamePassPurchaseFinished)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("GamePassId", "0"))
	self:addOutput(IO.Output.new("WasPurchased", "false"))
	
	return self
end

function PromptGamePassPurchaseFinished:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("GamePassId").Value = "gamePassId"
	self:getOutput("WasPurchased").Value = "wasPurchased"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return 'game:GetService("MarketplaceService").PromptGamePassPurchaseFinished:Connect(function(player, gamePassId, wasPurchased)\n' .. indentCode(body) .. "end)\n"
end

return PromptGamePassPurchaseFinished
