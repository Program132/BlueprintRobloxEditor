local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local RemoveReplicationFocus = {}
RemoveReplicationFocus.__index = RemoveReplicationFocus
setmetatable(RemoveReplicationFocus, Node)

function RemoveReplicationFocus.new()
	local self = Node.new("Player RemoveReplicationFocus", NodeType.METHOD)
	setmetatable(self, RemoveReplicationFocus)
	self:editTitle("Remove Replication Focus")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Part", "nil"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function RemoveReplicationFocus:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local part = self:getInput("Part").Value or "nil"
	return `{inst}:RemoveReplicationFocus({part})\n`
end

return RemoveReplicationFocus
