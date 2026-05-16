local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnTeleport = {}
OnTeleport.__index = OnTeleport
setmetatable(OnTeleport, Node)

function OnTeleport.new()
	local self = Node.new("Player OnTeleport", NodeType.EVENT)
	setmetatable(self, OnTeleport)
	self:editTitle("On Teleport")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("TeleportState", "Enum.TeleportState.Requested"))
	self:addOutput(IO.Output.new("PlaceId", "0"))
	self:addOutput(IO.Output.new("SpawnName", "\"\""))

	return self
end

function OnTeleport:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("TeleportState").Value = "teleportState"
	self:getOutput("PlaceId").Value = "placeId"
	self:getOutput("SpawnName").Value = "spawnName"

	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
			innerCode = indentCode(innerCode)
		end
	end

	return "game:GetService(\"Players\").PlayerAdded:Connect(function(player)\n" ..
		   "\tplayer.OnTeleport:Connect(function(teleportState, placeId, spawnName)\n" ..
		   innerCode .. "\n" ..
		   "\tend)\n" ..
		   "end)"
end

return OnTeleport
