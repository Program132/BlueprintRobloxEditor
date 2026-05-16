local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local RequestStreamAroundAsync = {}
RequestStreamAroundAsync.__index = RequestStreamAroundAsync
setmetatable(RequestStreamAroundAsync, Node)

function RequestStreamAroundAsync.new()
	local self = Node.new("Player RequestStreamAroundAsync", NodeType.METHOD)
	setmetatable(self, RequestStreamAroundAsync)
	self:editTitle("Request Stream Around")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Position", "Vector3.new(0,0,0)"))
	self:addInput(IO.Input.new("Timeout", "10"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function RequestStreamAroundAsync:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local pos = self:getInput("Position").Value or "Vector3.new(0,0,0)"
	local time = self:getInput("Timeout").Value or "10"
	return `{inst}:RequestStreamAroundAsync({pos}, {time})\n`
end

return RequestStreamAroundAsync
