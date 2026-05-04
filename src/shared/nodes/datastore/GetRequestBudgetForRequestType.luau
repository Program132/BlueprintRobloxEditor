local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetRequestBudgetForRequestType = {}
GetRequestBudgetForRequestType.__index = GetRequestBudgetForRequestType
setmetatable(GetRequestBudgetForRequestType, Node)

function GetRequestBudgetForRequestType.new()
	local self = Node.new("DataStoreService GetRequestBudgetForRequestType", NodeType.FUNCTION)
	setmetatable(self, GetRequestBudgetForRequestType)
	self:editColor(Color3.fromRGB(180, 40, 40))
	
	self:addInput(IO.Input.new("RequestType", "Enum.DataStoreRequestType.GetAsync"))
	self:addOutput(IO.Output.new("Budget", "0"))
	
	return self
end

function GetRequestBudgetForRequestType:toLuau()
	local requestType = self:getInput("RequestType").Value or "Enum.DataStoreRequestType.GetAsync"
	self:getOutput("Budget").Value = `game:GetService("DataStoreService"):GetRequestBudgetForRequestType({requestType})`
	return ""
end

return GetRequestBudgetForRequestType
