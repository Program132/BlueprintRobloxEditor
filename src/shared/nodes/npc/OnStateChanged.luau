local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnStateChanged = {}
OnStateChanged.__index = OnStateChanged
setmetatable(OnStateChanged, Node)

function OnStateChanged.new()
	local self = Node.new("NPC On State Changed", NodeType.EVENT)
	setmetatable(self, OnStateChanged)
	self:editTitle("On State Changed")
	self:editColor(Color3.fromRGB(200, 30, 30))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("OldState", "nil"))
	self:addOutput(IO.Output.new("NewState", "nil"))

	return self
end

function OnStateChanged:toLuau(block, visited, indentCode)
	self:getOutput("OldState").Value = "oldState"
	self:getOutput("NewState").Value = "newState"
	local innerCode = ""
	if block and block.run_from_port then
		innerCode = block:run_from_port(self, "Exec", visited)
		if indentCode then
			innerCode = indentCode(innerCode)
		end
	end

	return "humanoid.StateChanged:Connect(function(oldState, newState)\n" .. innerCode .. "\nend)"
end

return OnStateChanged
