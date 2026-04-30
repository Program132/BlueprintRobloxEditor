local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetSubscriptionProductInfoAsync = {}
GetSubscriptionProductInfoAsync.__index = GetSubscriptionProductInfoAsync
setmetatable(GetSubscriptionProductInfoAsync, Node)

function GetSubscriptionProductInfoAsync.new()
	local self = Node.new("GetSubscriptionProductInfoAsync", NodeType.FUNCTION)
	setmetatable(self, GetSubscriptionProductInfoAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("SubscriptionId", "''"))
	self:addOutput(IO.Output.new("Info", "nil"))
	
	return self
end

function GetSubscriptionProductInfoAsync:toLuau()
	local subId = self:getInput("SubscriptionId").Value or "''"
	self:getOutput("Info").Value = `game:GetService("MarketplaceService"):GetSubscriptionProductInfoAsync({subId})`
	return ""
end

return GetSubscriptionProductInfoAsync
