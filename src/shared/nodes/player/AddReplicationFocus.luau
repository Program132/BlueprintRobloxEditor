local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local AddReplicationFocus = {}
AddReplicationFocus.__index = AddReplicationFocus
setmetatable(AddReplicationFocus, Node)

function AddReplicationFocus.new()
	local self = Node.new("Player AddReplicationFocus", NodeType.METHOD)
	setmetatable(self, AddReplicationFocus)
	self:editTitle("Add Replication Focus")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addInput(IO.Input.new("Part", "nil", false, nil, "BasePart"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function AddReplicationFocus:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local part = self:getInput("Part").Value or "nil"
	return `{inst}:AddReplicationFocus({part})\n`
end

return AddReplicationFocus
