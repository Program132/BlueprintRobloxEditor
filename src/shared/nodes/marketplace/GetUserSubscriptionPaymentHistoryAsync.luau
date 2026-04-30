local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetUserSubscriptionPaymentHistoryAsync = {}
GetUserSubscriptionPaymentHistoryAsync.__index = GetUserSubscriptionPaymentHistoryAsync
setmetatable(GetUserSubscriptionPaymentHistoryAsync, Node)

function GetUserSubscriptionPaymentHistoryAsync.new()
	local self = Node.new("GetUserSubscriptionPaymentHistoryAsync", NodeType.FUNCTION)
	setmetatable(self, GetUserSubscriptionPaymentHistoryAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("User", "nil"))
	self:addInput(IO.Input.new("SubscriptionId", "''"))
	self:addOutput(IO.Output.new("History", "nil"))
	
	return self
end

function GetUserSubscriptionPaymentHistoryAsync:toLuau()
	local user = self:getInput("User").Value or "nil"
	local subId = self:getInput("SubscriptionId").Value or "''"
	self:getOutput("History").Value = `game:GetService("MarketplaceService"):GetUserSubscriptionPaymentHistoryAsync({user}, {subId})`
	return ""
end

return GetUserSubscriptionPaymentHistoryAsync
