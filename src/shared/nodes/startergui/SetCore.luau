local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SetCore = {}
SetCore.__index = SetCore
setmetatable(SetCore, Node)

function SetCore.new()
	local self = Node.new("StarterGui SetCore", NodeType.METHOD)
	setmetatable(self, SetCore)
	self:editColor(Color3.fromRGB(255, 50, 150))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("ParameterName", "''"))
	self:addInput(IO.Input.new("Value", "nil"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function SetCore:toLuau()
	local param = self:getInput("ParameterName").Value or "''"
	local val = self:getInput("Value").Value or "nil"
	return `game:GetService("StarterGui"):SetCore({param}, {val})\n`
end

return SetCore
