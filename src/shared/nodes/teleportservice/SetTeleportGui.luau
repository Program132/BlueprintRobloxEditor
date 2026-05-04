local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SetTeleportGui = {}
SetTeleportGui.__index = SetTeleportGui
setmetatable(SetTeleportGui, Node)

function SetTeleportGui.new()
	local self = Node.new("TeleportService SetTeleportGui", NodeType.METHOD)
	setmetatable(self, SetTeleportGui)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Gui", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function SetTeleportGui:toLuau()
	local gui = self:getInput("Gui").Value or "nil"
	return `game:GetService("TeleportService"):SetTeleportGui({gui})\n`
end

return SetTeleportGui
