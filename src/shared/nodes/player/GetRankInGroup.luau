local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetRankInGroup = {}
GetRankInGroup.__index = GetRankInGroup
setmetatable(GetRankInGroup, Node)

function GetRankInGroup.new()
	local self = Node.new("Player GetRankInGroup", NodeType.FUNCTION)
	setmetatable(self, GetRankInGroup)
	self:editTitle("Get Rank In Group")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addInput(IO.Input.new("GroupId", "0", false, nil, "number"))
	self:addOutput(IO.Output.new("Result", "0", false, nil, "number"))

	return self
end

function GetRankInGroup:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local group = self:getInput("GroupId").Value or "0"
	local resultVar = "rank_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:GetRankInGroup({group})\n`
end

return GetRankInGroup
