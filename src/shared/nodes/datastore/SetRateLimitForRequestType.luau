local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SetRateLimitForRequestType = {}
SetRateLimitForRequestType.__index = SetRateLimitForRequestType
setmetatable(SetRateLimitForRequestType, Node)

function SetRateLimitForRequestType.new()
	local self = Node.new("DataStoreService SetRateLimitForRequestType", NodeType.METHOD)
	setmetatable(self, SetRateLimitForRequestType)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("RequestType", "Enum.DataStoreRequestType.GetAsync"))
	self:addInput(IO.Input.new("BaseLimit", "1"))
	self:addInput(IO.Input.new("PerPlayerLimit", "1"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function SetRateLimitForRequestType:toLuau()
	local requestType = self:getInput("RequestType").Value or "Enum.DataStoreRequestType.GetAsync"
	local baseLimit = self:getInput("BaseLimit").Value or "1"
	local perPlayerLimit = self:getInput("PerPlayerLimit").Value or "1"
	
	return `game:GetService("DataStoreService"):SetRateLimitForRequestType({requestType}, {baseLimit}, {perPlayerLimit})\n`
end

return SetRateLimitForRequestType
