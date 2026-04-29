local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToTool = {}
InstanceToTool.__index = InstanceToTool
setmetatable(InstanceToTool, Node)

local PROPERTIES = {
	"Archivable", "CanBeDropped", "Capabilities", "Enabled", "Grip", "GripForward",
	"GripPos", "GripRight", "GripUp", "ManualActivationOnly", "Name", "Parent",
	"PredictionMode", "RequiresHandle", "Sandboxed", "TextureId", "ToolTip", "UniqueId"
}

function InstanceToTool.new()
	local self = Node.new("Instance To Tool", NodeType.FUNCTION)
	setmetatable(self, InstanceToTool)

	self:editTitle("Instance To Tool")
	self:editColor(Color3.fromRGB(120, 100, 180)) -- Conversion color

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToTool:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToTool
