local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SetWalkSpeed = {}
SetWalkSpeed.__index = SetWalkSpeed
setmetatable(SetWalkSpeed, Node)

function SetWalkSpeed.new()
	local self = Node.new("NPC Set WalkSpeed", NodeType.METHOD)
	setmetatable(self, SetWalkSpeed)
	self:editTitle("Set WalkSpeed")
	self:editColor(Color3.fromRGB(50, 150, 100))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Speed", "16", false, nil, "number"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SetWalkSpeed:toLuau()
	local speed = self:getInput("Speed").Value or "16"
	return "humanoid.WalkSpeed = " .. speed .. "\n"
end

return SetWalkSpeed
