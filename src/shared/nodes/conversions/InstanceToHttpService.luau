local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceToHttpService = {}
InstanceToHttpService.__index = InstanceToHttpService
setmetatable(InstanceToHttpService, Node)

function InstanceToHttpService.new()
	local self = Node.new("Instance to HttpService", NodeType.FUNCTION)
	setmetatable(self, InstanceToHttpService)
	self:editColor(Color3.fromRGB(50, 150, 200))
	
	self:addInput(IO.Input.new("Instance", "game:GetService('HttpService')"))
	
	self:addOutput(IO.Output.new("HttpEnabled", "false"))
	
	return self
end

function InstanceToHttpService:toLuau()
	local uis = self:getInput("Instance").Value or "game:GetService('HttpService')"
	
	self:getOutput("HttpEnabled").Value = `{uis}.HttpEnabled`
	
	return ""
end

return InstanceToHttpService
