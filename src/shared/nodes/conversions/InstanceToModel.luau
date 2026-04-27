local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToModel = {}
InstanceToModel.__index = InstanceToModel
setmetatable(InstanceToModel, Node)

local PROPERTIES = {
	"LevelOfDetail", "ModelStreamingMode", "PrimaryPart", "Scale", "WorldPivot"
}

function InstanceToModel.new()
	local self = Node.new("Instance To Model", NodeType.FUNCTION)
	setmetatable(self, InstanceToModel)

	self:editTitle("Instance To Model")
	self:editColor(Color3.fromRGB(120, 100, 180))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToModel:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToModel
