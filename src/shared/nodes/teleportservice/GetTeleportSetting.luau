local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetTeleportSetting = {}
GetTeleportSetting.__index = GetTeleportSetting
setmetatable(GetTeleportSetting, Node)

function GetTeleportSetting.new()
	local self = Node.new("TeleportService GetTeleportSetting", NodeType.FUNCTION)
	setmetatable(self, GetTeleportSetting)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addInput(IO.Input.new("Setting", '""'))
	self:addOutput(IO.Output.new("Value", "nil"))
	
	return self
end

function GetTeleportSetting:toLuau()
	local setting = self:getInput("Setting").Value or '""'
	self:getOutput("Value").Value = `game:GetService("TeleportService"):GetTeleportSetting({setting})`
	return ""
end

return GetTeleportSetting
