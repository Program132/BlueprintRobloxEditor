local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Types = {
	"SSE", "RawStream", "WebSocket"
}

local WebStreamClientTypeNode = {}
WebStreamClientTypeNode.__index = WebStreamClientTypeNode
setmetatable(WebStreamClientTypeNode, Node)

function WebStreamClientTypeNode.new()
	local self = Node.new("Enum WebStreamClientType", NodeType.ENUM)
	setmetatable(self, WebStreamClientTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "Default", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.WebStreamClientType.Default"))
	
	return self
end

function WebStreamClientTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.WebStreamClientType.{selected}`
	return ""
end

return WebStreamClientTypeNode
