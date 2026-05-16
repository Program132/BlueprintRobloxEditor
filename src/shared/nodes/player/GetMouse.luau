local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetMouse = {}
GetMouse.__index = GetMouse
setmetatable(GetMouse, Node)

function GetMouse.new()
	local self = Node.new("Player GetMouse", NodeType.FUNCTION)
	setmetatable(self, GetMouse)
	self:editTitle("Get Mouse")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addOutput(IO.Output.new("Result", "nil"))

	return self
end

function GetMouse:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local resultVar = "mouse_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:GetMouse()\n`
end

return GetMouse
