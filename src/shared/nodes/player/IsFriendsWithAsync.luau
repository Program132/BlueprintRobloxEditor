local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local IsFriendsWithAsync = {}
IsFriendsWithAsync.__index = IsFriendsWithAsync
setmetatable(IsFriendsWithAsync, Node)

function IsFriendsWithAsync.new()
	local self = Node.new("Player IsFriendsWithAsync", NodeType.FUNCTION)
	setmetatable(self, IsFriendsWithAsync)
	self:editTitle("Is Friends With (Async)")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addInput(IO.Input.new("UserId", "0", false, nil, "number"))
	self:addOutput(IO.Output.new("Result", "false", false, nil, "boolean"))

	return self
end

function IsFriendsWithAsync:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local user = self:getInput("UserId").Value or "0"
	local resultVar = "isFriend_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:IsFriendsWithAsync({user})\n`
end

return IsFriendsWithAsync
