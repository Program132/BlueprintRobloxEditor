local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Modes = { "Default", "Pixelated" }

local ResamplerModeNode = {}
ResamplerModeNode.__index = ResamplerModeNode
setmetatable(ResamplerModeNode, Node)

function ResamplerModeNode.new()
	local self = Node.new("Enum ResamplerMode", NodeType.ENUM)
	setmetatable(self, ResamplerModeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Mode", "Default", false, Modes))
	self:addOutput(IO.Output.new("Enum", "Enum.ResamplerMode.Default"))
	
	return self
end

function ResamplerModeNode:toLuau()
	local selected = self:getInput("Mode").Value
	self:getOutput("Enum").Value = `Enum.ResamplerMode.{selected}`
	return ""
end

return ResamplerModeNode
