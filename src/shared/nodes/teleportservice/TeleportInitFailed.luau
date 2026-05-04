local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local TeleportInitFailed = {}
TeleportInitFailed.__index = TeleportInitFailed
setmetatable(TeleportInitFailed, Node)

function TeleportInitFailed.new()
	local self = Node.new("Event TeleportService TeleportInitFailed", NodeType.EVENT)
	setmetatable(self, TeleportInitFailed)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("Result", "Enum.TeleportResult.Failure"))
	self:addOutput(IO.Output.new("ErrorMessage", '""'))
	self:addOutput(IO.Output.new("PlaceId", "0"))
	self:addOutput(IO.Output.new("TeleportOptions", "nil"))
	
	return self
end

function TeleportInitFailed:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Result").Value = "teleportResult"
	self:getOutput("ErrorMessage").Value = "errorMessage"
	self:getOutput("PlaceId").Value = "placeId"
	self:getOutput("TeleportOptions").Value = "teleportOptions"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("TeleportService").TeleportInitFailed:Connect(function(player, teleportResult, errorMessage, placeId, teleportOptions)\n` .. indentCode(body) .. "end)\n"
end

return TeleportInitFailed
