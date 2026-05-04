local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local TeleportAsync = {}
TeleportAsync.__index = TeleportAsync
setmetatable(TeleportAsync, Node)

function TeleportAsync.new()
	local self = Node.new("TeleportService TeleportAsync", NodeType.METHOD)
	setmetatable(self, TeleportAsync)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("PlaceId", "0"))
	self:addInput(IO.Input.new("Players", "{}"))
	self:addInput(IO.Input.new("TeleportOptions", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Result", "nil"))
	
	return self
end

function TeleportAsync:toLuau()
	local placeId = self:getInput("PlaceId").Value or "0"
	local players = self:getInput("Players").Value or "{}"
	local options = self:getInput("TeleportOptions").Value or "nil"
	local resVar = `result_{self.ID:gsub("-", "_")}`
	
	self:getOutput("Result").Value = resVar
	
	return `local {resVar} = game:GetService("TeleportService"):TeleportAsync({placeId}, {players}, {options})\n`
end

return TeleportAsync
