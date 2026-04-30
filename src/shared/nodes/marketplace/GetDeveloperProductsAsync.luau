local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetDeveloperProductsAsync = {}
GetDeveloperProductsAsync.__index = GetDeveloperProductsAsync
setmetatable(GetDeveloperProductsAsync, Node)

function GetDeveloperProductsAsync.new()
	local self = Node.new("MarketplaceService GetDeveloperProductsAsync", NodeType.FUNCTION)
	setmetatable(self, GetDeveloperProductsAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addOutput(IO.Output.new("Products", "nil"))
	
	return self
end

function GetDeveloperProductsAsync:toLuau()
	self:getOutput("Products").Value = `game:GetService("MarketplaceService"):GetDeveloperProductsAsync()`
	return ""
end

return GetDeveloperProductsAsync

