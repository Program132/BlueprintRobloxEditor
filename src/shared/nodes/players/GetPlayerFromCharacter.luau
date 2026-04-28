local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetPlayerFromCharacter = {}
GetPlayerFromCharacter.__index = GetPlayerFromCharacter
setmetatable(GetPlayerFromCharacter, Node)

function GetPlayerFromCharacter.new()
	local self = Node.new("Get Player From Character", NodeType.FUNCTION)
	setmetatable(self, GetPlayerFromCharacter)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addInput(IO.Input.new("Character", "nil"))
	self:addOutput(IO.Output.new("Player", "nil"))
	
	return self
end

function GetPlayerFromCharacter:toLuau()
	local char = self:getInput("Character").Value or "nil"
	self:getOutput("Player").Value = `game:GetService("Players"):GetPlayerFromCharacter({char})`
	return ""
end

return GetPlayerFromCharacter
