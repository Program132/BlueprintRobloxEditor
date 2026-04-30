local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetUserSubscriptionStatusAsync = {}
GetUserSubscriptionStatusAsync.__index = GetUserSubscriptionStatusAsync
setmetatable(GetUserSubscriptionStatusAsync, Node)

function GetUserSubscriptionStatusAsync.new()
	local self = Node.new("GetUserSubscriptionStatusAsync", NodeType.FUNCTION)
	setmetatable(self, GetUserSubscriptionStatusAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("User", "nil"))
	self:addInput(IO.Input.new("SubscriptionId", "''"))
	self:addOutput(IO.Output.new("Status", "nil"))
	
	return self
end

function GetUserSubscriptionStatusAsync:toLuau()
	local user = self:getInput("User").Value or "nil"
	local subId = self:getInput("SubscriptionId").Value or "''"
	self:getOutput("Status").Value = `game:GetService("MarketplaceService"):GetUserSubscriptionStatusAsync({user}, {subId})`
	return ""
end

return GetUserSubscriptionStatusAsync
