local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToRunService = {}
InstanceToRunService.__index = InstanceToRunService
setmetatable(InstanceToRunService, Node)

function InstanceToRunService.new()
	local self = Node.new("Instance to RunService", NodeType.FUNCTION)
	setmetatable(self, InstanceToRunService)
	self:editColor(Color3.fromRGB(120, 150, 100))
	
	self:addInput(IO.Input.new("Instance", "game:GetService('RunService')"))
	
	self:addOutput(IO.Output.new("ClientGitHash", "''"))
	self:addOutput(IO.Output.new("RunState", "Enum.RunState.Running"))
	
	return self
end

function InstanceToRunService:toLuau()
	local uis = self:getInput("Instance").Value or "game:GetService('RunService')"
	
	self:getOutput("ClientGitHash").Value = `{uis}.ClientGitHash`
	self:getOutput("RunState").Value = `{uis}:GetRunState()`
	
	return ""
end

return InstanceToRunService
