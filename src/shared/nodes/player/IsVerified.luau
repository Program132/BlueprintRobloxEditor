local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local IsVerified = {}
IsVerified.__index = IsVerified
setmetatable(IsVerified, Node)

function IsVerified.new()
	local self = Node.new("Player IsVerified", NodeType.FUNCTION)
	setmetatable(self, IsVerified)
	self:editTitle("Is Verified")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addOutput(IO.Output.new("Result", "false"))

	return self
end

function IsVerified:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local resultVar = "verified_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:IsVerified()\n`
end

return IsVerified
