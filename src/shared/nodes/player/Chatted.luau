local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Chatted = {}
Chatted.__index = Chatted
setmetatable(Chatted, Node)

function Chatted.new()
	local self = Node.new("Player Chatted", NodeType.EVENT)
	setmetatable(self, Chatted)
	self:editTitle("On Player Chatted")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil", false, nil, "Player"))
	self:addOutput(IO.Output.new("Message", "\"\"", false, nil, "string"))
	self:addOutput(IO.Output.new("Recipient", "nil", false, nil, "Player"))

	return self
end

function Chatted:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Message").Value = "message"
	self:getOutput("Recipient").Value = "recipient"

	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
			innerCode = indentCode(innerCode)
		end
	end

	return "game:GetService(\"Players\").PlayerAdded:Connect(function(player)\n" ..
		   "\tplayer.Chatted:Connect(function(message, recipient)\n" ..
		   innerCode .. "\n" ..
		   "\tend)\n" ..
		   "end)"
end

return Chatted
