local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ScreenOrientations = {
	"LandscapeLeft", "LandscapeRight", "Portrait", "Sensor"
}

local ScreenOrientationNode = {}
ScreenOrientationNode.__index = ScreenOrientationNode
setmetatable(ScreenOrientationNode, Node)

function ScreenOrientationNode.new()
	local self = Node.new("Enum ScreenOrientation", NodeType.ENUM)
	setmetatable(self, ScreenOrientationNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "LandscapeLeft", false, ScreenOrientations))
	self:addOutput(IO.Output.new("Enum", "Enum.ScreenOrientation.LandscapeLeft"))
	
	return self
end

function ScreenOrientationNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.ScreenOrientation.{selected}`
	return ""
end

return ScreenOrientationNode
