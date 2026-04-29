local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local Idled = {}
Idled.__index = Idled
setmetatable(Idled, Node)

function Idled.new()
	local self = Node.new("Idled", NodeType.EVENT)
	setmetatable(self, Idled)
	self:editColor(Color3.fromRGB(0, 160, 255))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("Time", "0"))
	
	return self
end

function Idled:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Time").Value = "time"
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `game:GetService("Players").PlayerAdded:Connect(function(player)\n` ..
		indentCode(`player.Idled:Connect(function(time)\n` ..
		indentCode(body) ..
		"end)\n") ..
		"end)\n"
end

return Idled
