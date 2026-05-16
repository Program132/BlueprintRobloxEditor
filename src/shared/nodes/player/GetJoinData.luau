local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetJoinData = {}
GetJoinData.__index = GetJoinData
setmetatable(GetJoinData, Node)

function GetJoinData.new()
	local self = Node.new("Player GetJoinData", NodeType.FUNCTION)
	setmetatable(self, GetJoinData)
	self:editTitle("Get Join Data")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addOutput(IO.Output.new("Result", "{}", false, nil, "table"))

	return self
end

function GetJoinData:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local resultVar = "joinData_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:GetJoinData()\n`
end

return GetJoinData
