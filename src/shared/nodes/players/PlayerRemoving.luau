local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PlayerRemoving = {}
PlayerRemoving.__index = PlayerRemoving
setmetatable(PlayerRemoving, Node)

function PlayerRemoving.new()
	local self = Node.new("PlayerRemoving", NodeType.EVENT)
	setmetatable(self, PlayerRemoving)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	
	return self
end

function PlayerRemoving:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("Players").PlayerRemoving:Connect(function(player)\n` .. indentCode(body) .. "end)\n"
end

return PlayerRemoving
