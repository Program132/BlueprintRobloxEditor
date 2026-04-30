local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local RtlTextSupportOptions = {
	"Default", "Disabled", "Enabled"
}

local RtlTextSupportNode = {}
RtlTextSupportNode.__index = RtlTextSupportNode
setmetatable(RtlTextSupportNode, Node)

function RtlTextSupportNode.new()
	local self = Node.new("Enum RtlTextSupport", NodeType.ENUM)
	setmetatable(self, RtlTextSupportNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Default", false, RtlTextSupportOptions))
	self:addOutput(IO.Output.new("Enum", "Enum.RtlTextSupport.Default"))
	
	return self
end

function RtlTextSupportNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.RtlTextSupport.{selected}`
	return ""
end

return RtlTextSupportNode
