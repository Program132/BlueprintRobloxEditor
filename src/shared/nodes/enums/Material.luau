local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Materials = {
	"Plastic", "SmoothPlastic", "Neon", "Wood", "WoodPlanks", "Marble", "Basalt", "Slate",
	"CrackedLava", "Concrete", "Limestone", "Granite", "Pavement", "Brick", "Pebble",
	"Cobblestone", "Rock", "Sandstone", "CorrodedMetal", "DiamondPlate", "Foil", "Metal",
	"Grass", "LeafyGrass", "Sand", "Fabric", "Snow", "Mud", "Ground", "Asphalt", "Salt",
	"Ice", "Glacier", "Glass", "ForceField", "Air", "Water", "Cardboard", "Carpet",
	"CeramicTiles", "ClayRoofTiles", "RoofShingles", "Leather", "Plaster", "Rubber"
}

local MaterialNode = {}
MaterialNode.__index = MaterialNode
setmetatable(MaterialNode, Node)

function MaterialNode.new()
	local self = Node.new("Enum Material", NodeType.ENUM)
	setmetatable(self, MaterialNode)
	self:editColor(Color3.fromRGB(150, 150, 40)) -- Yellow-ish for Enums
	
	self:addInput(IO.Input.new("Material", "Plastic", false, Materials))
	self:addOutput(IO.Output.new("Enum", "Enum.Material.Plastic"))
	
	return self
end

function MaterialNode:toLuau()
	local selected = self:getInput("Material").Value
	self:getOutput("Enum").Value = `Enum.Material.{selected}`
	return ""
end

return MaterialNode
