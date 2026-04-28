local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetUserIdFromNameAsync = {}
GetUserIdFromNameAsync.__index = GetUserIdFromNameAsync
setmetatable(GetUserIdFromNameAsync, Node)

function GetUserIdFromNameAsync.new()
	local self = Node.new("GetUserIdFromNameAsync", NodeType.FUNCTION)
	setmetatable(self, GetUserIdFromNameAsync)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addInput(IO.Input.new("Username", '""'))
	self:addOutput(IO.Output.new("UserId", "0"))
	
	return self
end

function GetUserIdFromNameAsync:toLuau()
	local username = self:getInput("Username").Value or '""'
	self:getOutput("UserId").Value = `game:GetService("Players"):GetUserIdFromNameAsync({username})`
	return ""
end

return GetUserIdFromNameAsync
