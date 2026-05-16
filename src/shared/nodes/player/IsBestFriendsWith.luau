local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local IsBestFriendsWith = {}
IsBestFriendsWith.__index = IsBestFriendsWith
setmetatable(IsBestFriendsWith, Node)

function IsBestFriendsWith.new()
	local self = Node.new("Player IsBestFriendsWith", NodeType.FUNCTION)
	setmetatable(self, IsBestFriendsWith)
	self:editTitle("Is Best Friends With")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("UserId", "0"))
	self:addOutput(IO.Output.new("Result", "false"))

	return self
end

function IsBestFriendsWith:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local user = self:getInput("UserId").Value or "0"
	local resultVar = "isBestFriend_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:IsBestFriendsWith({user})\n`
end

return IsBestFriendsWith
