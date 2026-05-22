local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local StopAnimation = {}
StopAnimation.__index = StopAnimation
setmetatable(StopAnimation, Node)

function StopAnimation.new()
	local self = Node.new("NPC Stop Animation", NodeType.METHOD)
	setmetatable(self, StopAnimation)
	self:editTitle("Stop Animation")
	self:editColor(Color3.fromRGB(150, 100, 200))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Track", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function StopAnimation:toLuau()
	local track = self:getInput("Track").Value or "nil"
	return "if " .. track .. " then " .. track .. ":Stop() end\n"
end

return StopAnimation
