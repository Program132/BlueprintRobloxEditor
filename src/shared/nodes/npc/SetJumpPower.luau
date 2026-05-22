local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SetJumpPower = {}
SetJumpPower.__index = SetJumpPower
setmetatable(SetJumpPower, Node)

function SetJumpPower.new()
	local self = Node.new("NPC Set JumpPower", NodeType.METHOD)
	setmetatable(self, SetJumpPower)
	self:editTitle("Set JumpPower")
	self:editColor(Color3.fromRGB(50, 150, 100))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Power", "50", false, nil, "number"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SetJumpPower:toLuau()
	local power = self:getInput("Power").Value or "50"
	return "humanoid.JumpPower = " .. power .. "\n"
end

return SetJumpPower
