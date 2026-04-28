local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PlayerAdded = {}
PlayerAdded.__index = PlayerAdded
setmetatable(PlayerAdded, Node)

function PlayerAdded.new()
	local self = Node.new("PlayerAdded", NodeType.EVENT)
	setmetatable(self, PlayerAdded)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	
	return self
end

function PlayerAdded:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("Players").PlayerAdded:Connect(function(player)\n` .. indentCode(body) .. "end)\n"
end

return PlayerAdded
