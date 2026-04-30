local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetUsersPriceLevelsAsync = {}
GetUsersPriceLevelsAsync.__index = GetUsersPriceLevelsAsync
setmetatable(GetUsersPriceLevelsAsync, Node)

function GetUsersPriceLevelsAsync.new()
	local self = Node.new("MarketplaceService GetUsersPriceLevelsAsync", NodeType.FUNCTION)
	setmetatable(self, GetUsersPriceLevelsAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("UserIds", "{}"))
	self:addOutput(IO.Output.new("PriceLevels", "nil"))
	
	return self
end

function GetUsersPriceLevelsAsync:toLuau()
	local userIds = self:getInput("UserIds").Value or "{}"
	self:getOutput("PriceLevels").Value = `game:GetService("MarketplaceService"):GetUsersPriceLevelsAsync({userIds})`
	return ""
end

return GetUsersPriceLevelsAsync

