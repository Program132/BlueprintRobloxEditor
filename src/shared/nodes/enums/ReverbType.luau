local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Types = {
	"NoReverb", "GenericReverb", "PaddedCell", "Room", "Bathroom",
	"LivingRoom", "StoneRoom", "Auditorium", "ConcertHall", "Cave",
	"Arena", "Hangar", "CarpettedHallway", "Hallway", "StoneCorridor",
	"Alley", "Forest", "City", "Mountains", "Quarry",
	"Plain", "ParkingLot", "SewerPipe", "UnderWater"
}

local ReverbTypeNode = {}
ReverbTypeNode.__index = ReverbTypeNode
setmetatable(ReverbTypeNode, Node)

function ReverbTypeNode.new()
	local self = Node.new("Enum ReverbType", NodeType.ENUM)
	setmetatable(self, ReverbTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "NoReverb", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.ReverbType.NoReverb"))
	
	return self
end

function ReverbTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.ReverbType.{selected}`
	return ""
end

return ReverbTypeNode
