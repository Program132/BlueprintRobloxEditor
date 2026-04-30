local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetProductInfoAsync = {}
GetProductInfoAsync.__index = GetProductInfoAsync
setmetatable(GetProductInfoAsync, Node)

function GetProductInfoAsync.new()
	local self = Node.new("GetProductInfoAsync", NodeType.FUNCTION)
	setmetatable(self, GetProductInfoAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("AssetId", "0"))
	self:addInput(IO.Input.new("InfoType", "Enum.InfoType.Asset"))
	self:addOutput(IO.Output.new("Info", "nil"))
	
	return self
end

function GetProductInfoAsync:toLuau()
	local assetId = self:getInput("AssetId").Value or "0"
	local infoType = self:getInput("InfoType").Value or "Enum.InfoType.Asset"
	self:getOutput("Info").Value = `game:GetService("MarketplaceService"):GetProductInfoAsync({assetId}, {infoType})`
	return ""
end

return GetProductInfoAsync
