local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Sizes = {
	"Size8", "Size9", "Size10", "Size11", "Size12", "Size14", "Size18",
	"Size24", "Size28", "Size32", "Size36", "Size42", "Size48", "Size60", "Size96"
}

local FontSizeNode = {}
FontSizeNode.__index = FontSizeNode
setmetatable(FontSizeNode, Node)

function FontSizeNode.new()
	local self = Node.new("Enum FontSize", NodeType.ENUM)
	setmetatable(self, FontSizeNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Size", "Size14", false, Sizes))
	self:addOutput(IO.Output.new("Enum", "Enum.FontSize.Size14"))
	
	return self
end

function FontSizeNode:toLuau()
	local selected = self:getInput("Size").Value
	self:getOutput("Enum").Value = `Enum.FontSize.{selected}`
	return ""
end

return FontSizeNode
