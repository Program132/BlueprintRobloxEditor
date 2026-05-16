local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local LoadCharacter = {}
LoadCharacter.__index = LoadCharacter
setmetatable(LoadCharacter, Node)

function LoadCharacter.new()
	local self = Node.new("Player LoadCharacter", NodeType.METHOD)
	setmetatable(self, LoadCharacter)
	self:editTitle("Load Character")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function LoadCharacter:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	return `{inst}:LoadCharacter()\n`
end

return LoadCharacter
