local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnLoop = {}
OnLoop.__index = OnLoop
setmetatable(OnLoop, Node)

function OnLoop.new()
	local self = Node.new("NPC On Loop", NodeType.EVENT)
	setmetatable(self, OnLoop)
	self:editTitle("On Loop")
	self:editColor(Color3.fromRGB(200, 30, 100))

	self:addInput(IO.Input.new("Interval", "1", false, nil, "number"))

	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function OnLoop:toLuau(block, visited, indentCode)
	local interval = self:getInput("Interval").Value or "1"
	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(indentCode(innerCode))
		end
	end

	-- Run a safe loop that automatically terminates when character is destroyed or humanoid dies
	return "task.spawn(function()\n" ..
		   "\twhile char and char.Parent and humanoid.Health > 0 do\n" ..
		   innerCode ..
		   "\t\ttask.wait(" .. interval .. ")\n" ..
		   "\tend\n" ..
		   "end)"
end

return OnLoop
