local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetNetworkPing = {}
GetNetworkPing.__index = GetNetworkPing
setmetatable(GetNetworkPing, Node)

function GetNetworkPing.new()
	local self = Node.new("Player GetNetworkPing", NodeType.FUNCTION)
	setmetatable(self, GetNetworkPing)
	self:editTitle("Get Network Ping")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addOutput(IO.Output.new("Result", "0", false, nil, "number"))

	return self
end

function GetNetworkPing:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local resultVar = "ping_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:GetNetworkPing()\n`
end

return GetNetworkPing
