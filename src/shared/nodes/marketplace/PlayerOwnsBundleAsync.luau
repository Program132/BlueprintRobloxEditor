local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PlayerOwnsBundleAsync = {}
PlayerOwnsBundleAsync.__index = PlayerOwnsBundleAsync
setmetatable(PlayerOwnsBundleAsync, Node)

function PlayerOwnsBundleAsync.new()
	local self = Node.new("MarketplaceService PlayerOwnsBundleAsync", NodeType.FUNCTION)
	setmetatable(self, PlayerOwnsBundleAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("BundleId", "0"))
	self:addOutput(IO.Output.new("Owns", "false"))
	
	return self
end

function PlayerOwnsBundleAsync:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local bundleId = self:getInput("BundleId").Value or "0"
	self:getOutput("Owns").Value = `game:GetService("MarketplaceService"):PlayerOwnsBundleAsync({player}, {bundleId})`
	return ""
end

return PlayerOwnsBundleAsync

