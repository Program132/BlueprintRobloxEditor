local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local DistanceFromCharacter = {}
DistanceFromCharacter.__index = DistanceFromCharacter
setmetatable(DistanceFromCharacter, Node)

function DistanceFromCharacter.new()
	local self = Node.new("Player DistanceFromCharacter", NodeType.FUNCTION)
	setmetatable(self, DistanceFromCharacter)
	self:editTitle("Distance From Character")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Point", "Vector3.new(0,0,0)"))
	self:addOutput(IO.Output.new("Result", "0"))

	return self
end

function DistanceFromCharacter:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local point = self:getInput("Point").Value or "Vector3.new(0,0,0)"
	
	local resultVar = "dist_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	
	return `local {resultVar} = {inst}:DistanceFromCharacter({point})\n`
end

return DistanceFromCharacter
