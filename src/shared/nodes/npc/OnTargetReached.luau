local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnTargetReached = {}
OnTargetReached.__index = OnTargetReached
setmetatable(OnTargetReached, Node)

function OnTargetReached.new()
	local self = Node.new("NPC On Target Reached", NodeType.EVENT)
	setmetatable(self, OnTargetReached)
	self:editTitle("On Target Reached")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Reached", "false", false, nil, "boolean"))

	return self
end

function OnTargetReached:toLuau(block, visited, indentCode)
	self:getOutput("Reached").Value = "reached"
	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
		end
	end

	return "humanoid.MoveToFinished:Connect(function(reached)\n" .. innerCode .. "\nend)"
end

return OnTargetReached
