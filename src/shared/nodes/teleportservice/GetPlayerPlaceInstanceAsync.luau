local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetPlayerPlaceInstanceAsync = {}
GetPlayerPlaceInstanceAsync.__index = GetPlayerPlaceInstanceAsync
setmetatable(GetPlayerPlaceInstanceAsync, Node)

function GetPlayerPlaceInstanceAsync.new()
	local self = Node.new("TeleportService GetPlayerPlaceInstanceAsync", NodeType.FUNCTION)
	setmetatable(self, GetPlayerPlaceInstanceAsync)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addInput(IO.Input.new("UserId", "0"))
	
	self:addOutput(IO.Output.new("InstanceId", "nil"))
	self:addOutput(IO.Output.new("PlaceId", "0"))
	
	return self
end

function GetPlayerPlaceInstanceAsync:toLuau()
	local userId = self:getInput("UserId").Value or "0"
	
	self:getOutput("InstanceId").Value = `(select(1, game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync({userId})))`
	self:getOutput("PlaceId").Value = `(select(2, game:GetService("TeleportService"):GetPlayerPlaceInstanceAsync({userId})))`
	
	return ""
end

return GetPlayerPlaceInstanceAsync
