local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local LocalPlayerArrivedFromTeleport = {}
LocalPlayerArrivedFromTeleport.__index = LocalPlayerArrivedFromTeleport
setmetatable(LocalPlayerArrivedFromTeleport, Node)

function LocalPlayerArrivedFromTeleport.new()
	local self = Node.new("Event TeleportService LocalPlayerArrivedFromTeleport", NodeType.EVENT)
	setmetatable(self, LocalPlayerArrivedFromTeleport)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("LoadingGui", "nil"))
	self:addOutput(IO.Output.new("TeleportData", "nil"))
	
	return self
end

function LocalPlayerArrivedFromTeleport:toLuau(block, visited, indentCode)
	self:getOutput("LoadingGui").Value = "loadingGui"
	self:getOutput("TeleportData").Value = "dataTable"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("TeleportService").LocalPlayerArrivedFromTeleport:Connect(function(loadingGui, dataTable)\n` .. indentCode(body) .. "end)\n"
end

return LocalPlayerArrivedFromTeleport
