local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Fonts = {
	"Legacy", "Arial", "ArialBold", "SourceSans", "SourceSansBold", "SourceSansLight",
	"SourceSansItalic", "Bodoni", "Garamond", "Cartoon", "Code", "Highway", "SciFi",
	"Arcade", "Fantasy", "Antique", "SourceSansSemibold", "Gotham", "GothamMedium",
	"GothamBold", "GothamBlack", "AmaticSC", "Bangers", "Creepster", "DenkOne",
	"Fondamento", "FredokaOne", "GrenzeGotisch", "IndieFlower", "JosefinSans",
	"Jura", "Kalam", "LuckiestGuy", "Merriweather", "Michroma", "Nunito", "Oswald",
	"PatrickHand", "PermanentMarker", "Roboto", "RobotoCondensed", "RobotoMono",
	"Sarpanch", "SpecialElite", "TitilliumWeb", "Ubuntu", "BuilderSans",
	"BuilderSansMedium", "BuilderSansBold", "BuilderSansExtraBold", "Arimo", "ArimoBold", "Unknown"
}

local FontNode = {}
FontNode.__index = FontNode
setmetatable(FontNode, Node)

function FontNode.new()
	local self = Node.new("Enum Font", NodeType.ENUM)
	setmetatable(self, FontNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Font", "SourceSans", false, Fonts))
	self:addOutput(IO.Output.new("Enum", "Enum.Font.SourceSans"))
	
	return self
end

function FontNode:toLuau()
	local selected = self:getInput("Font").Value
	self:getOutput("Enum").Value = `Enum.Font.{selected}`
	return ""
end

return FontNode
