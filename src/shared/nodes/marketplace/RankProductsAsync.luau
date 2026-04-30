local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local RankProductsAsync = {}
RankProductsAsync.__index = RankProductsAsync
setmetatable(RankProductsAsync, Node)

function RankProductsAsync.new()
	local self = Node.new("MarketplaceService RankProductsAsync", NodeType.FUNCTION)
	setmetatable(self, RankProductsAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("ProductIdentifiers", "{}"))
	self:addOutput(IO.Output.new("Ranked", "nil"))
	
	return self
end

function RankProductsAsync:toLuau()
	local ids = self:getInput("ProductIdentifiers").Value or "{}"
	self:getOutput("Ranked").Value = `game:GetService("MarketplaceService"):RankProductsAsync({ids})`
	return ""
end

return RankProductsAsync

