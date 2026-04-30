local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PlayerOwnsAssetAsync = {}
PlayerOwnsAssetAsync.__index = PlayerOwnsAssetAsync
setmetatable(PlayerOwnsAssetAsync, Node)

function PlayerOwnsAssetAsync.new()
	local self = Node.new("MarketplaceService PlayerOwnsAssetAsync", NodeType.FUNCTION)
	setmetatable(self, PlayerOwnsAssetAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("AssetId", "0"))
	self:addOutput(IO.Output.new("Owns", "false"))
	
	return self
end

function PlayerOwnsAssetAsync:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local assetId = self:getInput("AssetId").Value or "0"
	self:getOutput("Owns").Value = `game:GetService("MarketplaceService"):PlayerOwnsAssetAsync({player}, {assetId})`
	return ""
end

return PlayerOwnsAssetAsync

