local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local CharacterAdded = {}
CharacterAdded.__index = CharacterAdded
setmetatable(CharacterAdded, Node)

function CharacterAdded.new()
	local self = Node.new("CharacterAdded", NodeType.EVENT)
	setmetatable(self, CharacterAdded)
	self:editTitle("On Character Added")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("Character", "nil"))

	return self
end

function CharacterAdded:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Character").Value = "character"

	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
			-- Double indent because of the nested PlayerAdded
			innerCode = indentCode(innerCode)
		end
	end

	return "game:GetService(\"Players\").PlayerAdded:Connect(function(player)\n" ..
		   "\tplayer.CharacterAdded:Connect(function(character)\n" ..
		   innerCode .. "\n" ..
		   "\tend)\n" ..
		   "end)"
end

return CharacterAdded
