local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SetSuperSafeChat = {}
SetSuperSafeChat.__index = SetSuperSafeChat
setmetatable(SetSuperSafeChat, Node)

function SetSuperSafeChat.new()
	local self = Node.new("Player SetSuperSafeChat", NodeType.METHOD)
	setmetatable(self, SetSuperSafeChat)
	self:editTitle("Set Super Safe Chat")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Value", "true"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SetSuperSafeChat:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local val = self:getInput("Value").Value or "true"
	return `{inst}:SetSuperSafeChat({val})\n`
end

return SetSuperSafeChat
