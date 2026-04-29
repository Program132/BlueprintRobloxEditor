local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local Chatted = {}
Chatted.__index = Chatted
setmetatable(Chatted, Node)

function Chatted.new()
	local self = Node.new("Chatted", NodeType.EVENT)
	setmetatable(self, Chatted)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("Message", "''"))
	self:addOutput(IO.Output.new("Recipient", "nil"))
	
	return self
end

function Chatted:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Message").Value = "message"
	self:getOutput("Recipient").Value = "recipient"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("Players").PlayerAdded:Connect(function(player)\n` ..
		indentCode(`player.Chatted:Connect(function(message, recipient)\n` ..
		indentCode(body) ..
		"end)\n") ..
		"end)\n"
end

return Chatted
