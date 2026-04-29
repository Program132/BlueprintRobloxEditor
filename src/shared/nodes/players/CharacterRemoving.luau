local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local CharacterRemoving = {}
CharacterRemoving.__index = CharacterRemoving
setmetatable(CharacterRemoving, Node)

function CharacterRemoving.new()
	local self = Node.new("CharacterRemoving", NodeType.EVENT)
	setmetatable(self, CharacterRemoving)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("Character", "nil"))
	
	return self
end

function CharacterRemoving:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Character").Value = "character"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("Players").PlayerAdded:Connect(function(player)\n` ..
		indentCode(`player.CharacterRemoving:Connect(function(character)\n` ..
		indentCode(body) ..
		"end)\n") ..
		"end)\n"
end

return CharacterRemoving
