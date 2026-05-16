local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local WaitForDataReady = {}
WaitForDataReady.__index = WaitForDataReady
setmetatable(WaitForDataReady, Node)

function WaitForDataReady.new()
	local self = Node.new("Player WaitForDataReady", NodeType.FUNCTION)
	setmetatable(self, WaitForDataReady)
	self:editTitle("Wait For Data Ready")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addOutput(IO.Output.new("Result", "false"))

	return self
end

function WaitForDataReady:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local resultVar = "ready_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:WaitForDataReady()\n`
end

return WaitForDataReady
