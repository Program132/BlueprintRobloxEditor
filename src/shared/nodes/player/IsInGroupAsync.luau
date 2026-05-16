local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local IsInGroupAsync = {}
IsInGroupAsync.__index = IsInGroupAsync
setmetatable(IsInGroupAsync, Node)

function IsInGroupAsync.new()
	local self = Node.new("Player IsInGroupAsync", NodeType.FUNCTION)
	setmetatable(self, IsInGroupAsync)
	self:editTitle("Is In Group (Async)")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("GroupId", "0"))
	self:addOutput(IO.Output.new("Result", "false"))

	return self
end

function IsInGroupAsync:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local group = self:getInput("GroupId").Value or "0"
	local resultVar = "inGroup_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:IsInGroupAsync({group})\n`
end

return IsInGroupAsync
