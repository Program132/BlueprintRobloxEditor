local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetRobloxSubscriptionDetailsAsync = {}
GetRobloxSubscriptionDetailsAsync.__index = GetRobloxSubscriptionDetailsAsync
setmetatable(GetRobloxSubscriptionDetailsAsync, Node)

function GetRobloxSubscriptionDetailsAsync.new()
	local self = Node.new("GetRobloxSubscriptionDetailsAsync", NodeType.FUNCTION)
	setmetatable(self, GetRobloxSubscriptionDetailsAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Player", "nil"))
	self:addOutput(IO.Output.new("Details", "nil"))
	
	return self
end

function GetRobloxSubscriptionDetailsAsync:toLuau()
	local player = self:getInput("Player").Value or "nil"
	self:getOutput("Details").Value = `game:GetService("MarketplaceService"):GetRobloxSubscriptionDetailsAsync({player})`
	return ""
end

return GetRobloxSubscriptionDetailsAsync
