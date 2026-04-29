local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local OnTeleport = {}
OnTeleport.__index = OnTeleport
setmetatable(OnTeleport, Node)

function OnTeleport.new()
	local self = Node.new("OnTeleport", NodeType.EVENT)
	setmetatable(self, OnTeleport)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("TeleportState", "nil"))
	self:addOutput(IO.Output.new("PlaceId", "0"))
	self:addOutput(IO.Output.new("SpawnName", "''"))
	
	return self
end

function OnTeleport:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("TeleportState").Value = "teleportState"
	self:getOutput("PlaceId").Value = "placeId"
	self:getOutput("SpawnName").Value = "spawnName"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("Players").PlayerAdded:Connect(function(player)\n` ..
		indentCode(`player.OnTeleport:Connect(function(teleportState, placeId, spawnName)\n` ..
		indentCode(body) ..
		"end)\n") ..
		"end)\n"
end

return OnTeleport
