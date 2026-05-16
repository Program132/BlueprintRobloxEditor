local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local CharacterRemoving = {}
CharacterRemoving.__index = CharacterRemoving
setmetatable(CharacterRemoving, Node)

function CharacterRemoving.new()
	local self = Node.new("Player CharacterRemoving", NodeType.EVENT)
	setmetatable(self, CharacterRemoving)
	self:editTitle("On Character Removing")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil", false, nil, "Player"))
	self:addOutput(IO.Output.new("Character", "nil", false, nil, "Model"))

	return self
end

function CharacterRemoving:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Character").Value = "character"

	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
			innerCode = indentCode(innerCode)
		end
	end

	return "game:GetService(\"Players\").PlayerAdded:Connect(function(player)\n" ..
		   "\tplayer.CharacterRemoving:Connect(function(character)\n" ..
		   innerCode .. "\n" ..
		   "\tend)\n" ..
		   "end)"
end

return CharacterRemoving
