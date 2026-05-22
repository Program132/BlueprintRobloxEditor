local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnChildAdded = {}
OnChildAdded.__index = OnChildAdded
setmetatable(OnChildAdded, Node)

function OnChildAdded.new()
	local self = Node.new("NPC On Child Added", NodeType.EVENT)
	setmetatable(self, OnChildAdded)
	self:editTitle("On Child Added")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Child", "nil", false, nil, "Instance"))

	return self
end

function OnChildAdded:toLuau(block, visited, indentCode)
	self:getOutput("Child").Value = "child"
	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
		end
	end

	return "char.ChildAdded:Connect(function(child)\n" .. innerCode .. "\nend)"
end

return OnChildAdded
