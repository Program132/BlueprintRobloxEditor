local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local ClearCharacterAppearance = {}
ClearCharacterAppearance.__index = ClearCharacterAppearance
setmetatable(ClearCharacterAppearance, Node)

function ClearCharacterAppearance.new()
	local self = Node.new("Player ClearCharacterAppearance", NodeType.METHOD)
	setmetatable(self, ClearCharacterAppearance)
	self:editTitle("Clear Character Appearance")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function ClearCharacterAppearance:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	return `{inst}:ClearCharacterAppearance()\n`
end

return ClearCharacterAppearance
