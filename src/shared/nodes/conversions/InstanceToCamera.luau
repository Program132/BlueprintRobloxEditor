local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToCamera = {}
InstanceToCamera.__index = InstanceToCamera
setmetatable(InstanceToCamera, Node)

local PROPERTIES = {
	"CameraSubject", "CameraType", "CFrame", "DiagonalFieldOfView", "FieldOfView",
	"FieldOfViewMode", "Focus", "HeadLocked", "HeadScale", "MaxAxisFieldOfView",
	"NearPlaneZ", "ViewportSize", "VRTiltAndRollEnabled"
}

function InstanceToCamera.new()
	local self = Node.new("Instance To Camera", NodeType.FUNCTION)
	setmetatable(self, InstanceToCamera)

	self:editTitle("Instance To Camera")
	self:editColor(Color3.fromRGB(120, 100, 180))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToCamera:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToCamera
