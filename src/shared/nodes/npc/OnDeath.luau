local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnDeath = {}
OnDeath.__index = OnDeath
setmetatable(OnDeath, Node)

function OnDeath.new()
	local self = Node.new("NPC On Death", NodeType.EVENT)
	setmetatable(self, OnDeath)
	self:editTitle("On Death")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function OnDeath:toLuau(block, visited, indentCode)
	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
		end
	end

	return "humanoid.Died:Connect(function()\n" .. innerCode .. "\nend)"
end

return OnDeath
