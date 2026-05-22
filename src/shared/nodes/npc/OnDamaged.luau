local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnDamaged = {}
OnDamaged.__index = OnDamaged
setmetatable(OnDamaged, Node)

function OnDamaged.new()
	local self = Node.new("NPC On Damaged", NodeType.EVENT)
	setmetatable(self, OnDamaged)
	self:editTitle("On Damaged")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Health", "0", false, nil, "number"))

	return self
end

function OnDamaged:toLuau(block, visited, indentCode)
	self:getOutput("Health").Value = "currentHealth"
	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
		end
	end

	return "humanoid.HealthChanged:Connect(function(currentHealth)\n" .. innerCode .. "\nend)"
end

return OnDamaged
