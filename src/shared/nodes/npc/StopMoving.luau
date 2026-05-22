local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local StopMoving = {}
StopMoving.__index = StopMoving
setmetatable(StopMoving, Node)

function StopMoving.new()
	local self = Node.new("NPC Stop Moving", NodeType.METHOD)
	setmetatable(self, StopMoving)
	self:editTitle("Stop Moving")
	self:editColor(Color3.fromRGB(50, 150, 100))

	self:addInput(IO.Input.new("Exec", ""))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function StopMoving:toLuau()
	return "humanoid:Move(Vector3.new(0, 0, 0))\n"
end

return StopMoving
