local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetCore = {}
GetCore.__index = GetCore
setmetatable(GetCore, Node)

function GetCore.new()
	local self = Node.new("StarterGui GetCore", NodeType.FUNCTION)
	setmetatable(self, GetCore)
	self:editColor(Color3.fromRGB(255, 50, 150))
	
	self:addInput(IO.Input.new("ParameterName", "''"))
	self:addOutput(IO.Output.new("Result", "nil"))
	
	return self
end

function GetCore:toLuau()
	local param = self:getInput("ParameterName").Value or "''"
	self:getOutput("Result").Value = `game:GetService("StarterGui"):GetCore({param})`
	return ""
end

return GetCore
