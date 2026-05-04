local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetLocalPlayerTeleportData = {}
GetLocalPlayerTeleportData.__index = GetLocalPlayerTeleportData
setmetatable(GetLocalPlayerTeleportData, Node)

function GetLocalPlayerTeleportData.new()
	local self = Node.new("TeleportService GetLocalPlayerTeleportData", NodeType.FUNCTION)
	setmetatable(self, GetLocalPlayerTeleportData)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addOutput(IO.Output.new("Variant", "nil"))
	
	return self
end

function GetLocalPlayerTeleportData:toLuau()
	self:getOutput("Variant").Value = `game:GetService("TeleportService"):GetLocalPlayerTeleportData()`
	return ""
end

return GetLocalPlayerTeleportData
