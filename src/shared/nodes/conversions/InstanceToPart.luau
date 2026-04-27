local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToPart = {}
InstanceToPart.__index = InstanceToPart
setmetatable(InstanceToPart, Node)

local PROPERTIES = {
	"Anchored", "AssemblyAngularVelocity", "AssemblyCenterOfMass", "AssemblyLinearVelocity",
	"AssemblyMass", "AssemblyRootPart", "AudioCanCollide", "BackSurface", "BottomSurface",
	"BrickColor", "CanCollide", "CanQuery", "CanTouch", "CastShadow", "CenterOfMass",
	"CFrame", "CollisionGroup", "Color", "CurrentPhysicalProperties", "CustomPhysicalProperties",
	"EnableFluidForces", "ExtentsCFrame", "ExtentsSize", "FrontSurface", "LeftSurface",
	"LocalTransparencyModifier", "Locked", "Mass", "Massless", "Material", "MaterialVariant",
	"Orientation", "PivotOffset", "Position", "ReceiveAge", "Reflectance", "ResizeableFaces",
	"ResizeIncrement", "RightSurface", "RootPriority", "Rotation", "Size", "TopSurface",
	"Transparency", "Shape"
}

function InstanceToPart.new()
	local self = Node.new("Instance To Part", NodeType.FUNCTION)
	setmetatable(self, InstanceToPart)

	self:editTitle("Instance To Part")
	self:editColor(Color3.fromRGB(120, 100, 180))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToPart:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToPart
