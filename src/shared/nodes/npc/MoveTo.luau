local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local MoveTo = {}
MoveTo.__index = MoveTo
setmetatable(MoveTo, Node)

function MoveTo.new()
	local self = Node.new("NPC Move To", NodeType.METHOD)
	setmetatable(self, MoveTo)
	self:editTitle("Move To")
	self:editColor(Color3.fromRGB(50, 150, 100))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Position", "Vector3.new(0, 0, 0)", false, nil, "Vector3"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function MoveTo:toLuau()
	local pos = self:getInput("Position").Value or "Vector3.new(0, 0, 0)"
	return `humanoid:MoveTo({pos})\n`
end

return MoveTo
