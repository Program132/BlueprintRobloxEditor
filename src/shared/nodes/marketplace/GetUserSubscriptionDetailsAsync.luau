local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetUserSubscriptionDetailsAsync = {}
GetUserSubscriptionDetailsAsync.__index = GetUserSubscriptionDetailsAsync
setmetatable(GetUserSubscriptionDetailsAsync, Node)

function GetUserSubscriptionDetailsAsync.new()
	local self = Node.new("MarketplaceService GetUserSubscriptionDetailsAsync", NodeType.FUNCTION)
	setmetatable(self, GetUserSubscriptionDetailsAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("User", "nil"))
	self:addInput(IO.Input.new("SubscriptionId", "''"))
	self:addOutput(IO.Output.new("Details", "nil"))
	
	return self
end

function GetUserSubscriptionDetailsAsync:toLuau()
	local user = self:getInput("User").Value or "nil"
	local subId = self:getInput("SubscriptionId").Value or "''"
	self:getOutput("Details").Value = `game:GetService("MarketplaceService"):GetUserSubscriptionDetailsAsync({user}, {subId})`
	return ""
end

return GetUserSubscriptionDetailsAsync

