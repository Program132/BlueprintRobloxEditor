local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetRoleInGroup = {}
GetRoleInGroup.__index = GetRoleInGroup
setmetatable(GetRoleInGroup, Node)

function GetRoleInGroup.new()
	local self = Node.new("Player GetRoleInGroup", NodeType.FUNCTION)
	setmetatable(self, GetRoleInGroup)
	self:editTitle("Get Role In Group")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addInput(IO.Input.new("GroupId", "0", false, nil, "number"))
	self:addOutput(IO.Output.new("Result", "\"Guest\"", false, nil, "string"))

	return self
end

function GetRoleInGroup:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local group = self:getInput("GroupId").Value or "0"
	local resultVar = "role_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:GetRoleInGroup({group})\n`
end

return GetRoleInGroup
