local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local Types = {
	"ApplicationJson", "ApplicationXml", "ApplicationUrlEncoded", "TextPlain", "TextXml"
}

local HttpContentTypeNode = {}
HttpContentTypeNode.__index = HttpContentTypeNode
setmetatable(HttpContentTypeNode, Node)

function HttpContentTypeNode.new()
	local self = Node.new("Enum HttpContentType", NodeType.ENUM)
	setmetatable(self, HttpContentTypeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Type", "ApplicationJson", false, Types))
	self:addOutput(IO.Output.new("Enum", "Enum.HttpContentType.ApplicationJson"))
	
	return self
end

function HttpContentTypeNode:toLuau()
	local selected = self:getInput("Type").Value
	self:getOutput("Enum").Value = `Enum.HttpContentType.{selected}`
	return ""
end

return HttpContentTypeNode
