local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GameGlobal = {}
GameGlobal.__index = GameGlobal
setmetatable(GameGlobal, Node)

function GameGlobal.new()
	local self = Node.new("game", NodeType.FUNCTION)
	setmetatable(self, GameGlobal)
	self:editColor(Color3.fromRGB(200, 200, 200))

	self:addOutput(IO.Output.new("game", "game"))

	return self
end

function GameGlobal:toLuau()
	self:getOutput("game").Value = "game"
	return ""
end

return GameGlobal
