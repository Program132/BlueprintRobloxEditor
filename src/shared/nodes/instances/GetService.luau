local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetService = {}
GetService.__index = GetService
setmetatable(GetService, Node)

function GetService.new()
	local self = Node.new("Get Service", NodeType.FUNCTION)
	setmetatable(self, GetService)
	self:editColor(Color3.fromRGB(100, 180, 255))

	self:addInput(IO.Input.new("Service Name", "TweenService"))

	self:addOutput(IO.Output.new("Service", 'nil'))

	return self
end

function GetService:toLuau()
	local nameInput = self:getInput("Service Name").Value
	local name = nameInput:gsub('^"(.*)"$', "%1")
	
	self:getOutput("Service").Value = `game:GetService("{name}")`

	return ""
end

return GetService
