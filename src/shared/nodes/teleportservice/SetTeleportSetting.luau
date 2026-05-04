local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SetTeleportSetting = {}
SetTeleportSetting.__index = SetTeleportSetting
setmetatable(SetTeleportSetting, Node)

function SetTeleportSetting.new()
	local self = Node.new("TeleportService SetTeleportSetting", NodeType.METHOD)
	setmetatable(self, SetTeleportSetting)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Setting", '""'))
	self:addInput(IO.Input.new("Value", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function SetTeleportSetting:toLuau()
	local setting = self:getInput("Setting").Value or '""'
	local value = self:getInput("Value").Value or "nil"
	return `game:GetService("TeleportService"):SetTeleportSetting({setting}, {value})\n`
end

return SetTeleportSetting
