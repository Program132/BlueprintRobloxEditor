local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Idled = {}
Idled.__index = Idled
setmetatable(Idled, Node)

function Idled.new()
	local self = Node.new("Player Idled", NodeType.EVENT)
	setmetatable(self, Idled)
	self:editTitle("On Player Idled")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("Time", "0"))

	return self
end

function Idled:toLuau(block, visited, indentCode)
	self:getOutput("Player").Value = "player"
	self:getOutput("Time").Value = "time"

	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
			innerCode = indentCode(innerCode)
		end
	end

	return "game:GetService(\"Players\").PlayerAdded:Connect(function(player)\n" ..
		   "\tplayer.Idled:Connect(function(time)\n" ..
		   innerCode .. "\n" ..
		   "\tend)\n" ..
		   "end)"
end

return Idled
