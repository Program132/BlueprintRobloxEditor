local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetFriendsOnline = {}
GetFriendsOnline.__index = GetFriendsOnline
setmetatable(GetFriendsOnline, Node)

function GetFriendsOnline.new()
	local self = Node.new("Player GetFriendsOnline", NodeType.FUNCTION)
	setmetatable(self, GetFriendsOnline)
	self:editTitle("Get Friends Online")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addInput(IO.Input.new("MaxFriends", "200", false, nil, "number"))
	self:addOutput(IO.Output.new("Result", "{}", false, nil, "table"))

	return self
end

function GetFriendsOnline:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local max = self:getInput("MaxFriends").Value or "200"
	local resultVar = "friends_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:GetFriendsOnline({max})\n`
end

return GetFriendsOnline
