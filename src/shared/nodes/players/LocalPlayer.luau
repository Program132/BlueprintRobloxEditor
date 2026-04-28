local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local LocalPlayer = {}
LocalPlayer.__index = LocalPlayer
setmetatable(LocalPlayer, Node)

function LocalPlayer.new()
	local self = Node.new("LocalPlayer", NodeType.FUNCTION)
	setmetatable(self, LocalPlayer)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Player", "game:GetService('Players').LocalPlayer"))
	
	return self
end

function LocalPlayer:toLuau()
	self:getOutput("Player").Value = "game:GetService('Players').LocalPlayer"
	return ""
end

return LocalPlayer
