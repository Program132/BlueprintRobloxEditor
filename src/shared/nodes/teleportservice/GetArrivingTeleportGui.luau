local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetArrivingTeleportGui = {}
GetArrivingTeleportGui.__index = GetArrivingTeleportGui
setmetatable(GetArrivingTeleportGui, Node)

function GetArrivingTeleportGui.new()
	local self = Node.new("TeleportService GetArrivingTeleportGui", NodeType.FUNCTION)
	setmetatable(self, GetArrivingTeleportGui)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addOutput(IO.Output.new("Instance", "nil"))
	
	return self
end

function GetArrivingTeleportGui:toLuau()
	self:getOutput("Instance").Value = `game:GetService("TeleportService"):GetArrivingTeleportGui()`
	return ""
end

return GetArrivingTeleportGui
