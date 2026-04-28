local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetNameFromUserIdAsync = {}
GetNameFromUserIdAsync.__index = GetNameFromUserIdAsync
setmetatable(GetNameFromUserIdAsync, Node)

function GetNameFromUserIdAsync.new()
	local self = Node.new("GetNameFromUserIdAsync", NodeType.FUNCTION)
	setmetatable(self, GetNameFromUserIdAsync)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addInput(IO.Input.new("UserId", "0"))
	self:addOutput(IO.Output.new("Name", '""'))
	
	return self
end

function GetNameFromUserIdAsync:toLuau()
	local userId = self:getInput("UserId").Value or "0"
	self:getOutput("Name").Value = `game:GetService("Players"):GetNameFromUserIdAsync({userId})`
	return ""
end

return GetNameFromUserIdAsync
