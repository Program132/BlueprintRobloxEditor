local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local LoadCharacterWithHumanoidDescription = {}
LoadCharacterWithHumanoidDescription.__index = LoadCharacterWithHumanoidDescription
setmetatable(LoadCharacterWithHumanoidDescription, Node)

function LoadCharacterWithHumanoidDescription.new()
	local self = Node.new("Player LoadCharacterWithHumanoidDescription", NodeType.METHOD)
	setmetatable(self, LoadCharacterWithHumanoidDescription)
	self:editTitle("Load Character w/ Description")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("HumanoidDescription", "nil"))
	self:addInput(IO.Input.new("AssetTypeVerification", "Enum.AssetTypeVerification.Default"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function LoadCharacterWithHumanoidDescription:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local desc = self:getInput("HumanoidDescription").Value or "nil"
	local verif = self:getInput("AssetTypeVerification").Value or "Enum.AssetTypeVerification.Default"
	return `{inst}:LoadCharacterWithHumanoidDescription({desc}, {verif})\n`
end

return LoadCharacterWithHumanoidDescription
