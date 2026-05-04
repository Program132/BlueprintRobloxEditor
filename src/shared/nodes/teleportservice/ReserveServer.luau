local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ReserveServer = {}
ReserveServer.__index = ReserveServer
setmetatable(ReserveServer, Node)

function ReserveServer.new()
	local self = Node.new("TeleportService ReserveServer", NodeType.METHOD)
	setmetatable(self, ReserveServer)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("PlaceId", "0"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("AccessCode", '""'))
	self:addOutput(IO.Output.new("PrivateServerId", '""'))
	
	return self
end

function ReserveServer:toLuau()
	local placeId = self:getInput("PlaceId").Value or "0"
	local accessCodeVar = `accessCode_{self.ID:gsub("-", "_")}`
	local privateServerIdVar = `privateServerId_{self.ID:gsub("-", "_")}`
	
	self:getOutput("AccessCode").Value = accessCodeVar
	self:getOutput("PrivateServerId").Value = privateServerIdVar
	
	return `local {accessCodeVar}, {privateServerIdVar} = game:GetService("TeleportService"):ReserveServer({placeId})\n`
end

return ReserveServer
