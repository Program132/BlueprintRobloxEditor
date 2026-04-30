local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local RecommendTopProductsAsync = {}
RecommendTopProductsAsync.__index = RecommendTopProductsAsync
setmetatable(RecommendTopProductsAsync, Node)

function RecommendTopProductsAsync.new()
	local self = Node.new("MarketplaceService RecommendTopProductsAsync", NodeType.FUNCTION)
	setmetatable(self, RecommendTopProductsAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("InfoTypes", "{}"))
	self:addOutput(IO.Output.new("Recommended", "nil"))
	
	return self
end

function RecommendTopProductsAsync:toLuau()
	local types = self:getInput("InfoTypes").Value or "{}"
	self:getOutput("Recommended").Value = `game:GetService("MarketplaceService"):RecommendTopProductsAsync({types})`
	return ""
end

return RecommendTopProductsAsync

