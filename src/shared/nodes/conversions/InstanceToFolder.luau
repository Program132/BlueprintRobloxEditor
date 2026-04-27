local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToFolder = {}
InstanceToFolder.__index = InstanceToFolder
setmetatable(InstanceToFolder, Node)

local PROPERTIES = {
	"Archivable", "Capabilities", "Name", "Parent", "PredictionMode", "Sandboxed", "UniqueId"
}

function InstanceToFolder.new()
	local self = Node.new("Instance To Folder", NodeType.FUNCTION)
	setmetatable(self, InstanceToFolder)

	self:editTitle("Instance To Folder")
	self:editColor(Color3.fromRGB(120, 100, 180))

	self:addInput(IO.Input.new("Instance", "nil"))

	for _, prop in ipairs(PROPERTIES) do
		self:addOutput(IO.Output.new(prop, ""))
	end

	return self
end

function InstanceToFolder:toLuau()
	local instVar = self:getInput("Instance").Value or "nil"

	for _, prop in ipairs(PROPERTIES) do
		local output = self:getOutput(prop)
		output.Value = string.format("%s.%s", instVar, prop)
	end

	return ""
end

return InstanceToFolder
