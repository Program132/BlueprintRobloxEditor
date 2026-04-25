local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Lerp = {}
Lerp.__index = Lerp
setmetatable(Lerp, Node)

function Lerp.new()
	local self = Node.new("UDim2 Lerp", NodeType.FUNCTION)
	setmetatable(self, Lerp)
	self:editColor(Color3.fromRGB(0, 180, 200))

	self:addInput(IO.Input.new("UDim2", "UDim2.new(0, 0, 0, 0)"))
	self:addInput(IO.Input.new("Goal", "UDim2.new(1, 0, 1, 0)"))
	self:addInput(IO.Input.new("Alpha", "0.5"))

	self:addOutput(IO.Output.new("Result", "UDim2.new(0.5, 0, 0.5, 0)"))

	return self
end

function Lerp:toLuau()
	local udim = self:getInput("UDim2").Value
	local goal = self:getInput("Goal").Value
	local alpha = self:getInput("Alpha").Value

	self:getOutput("Result").Value = `{udim}:Lerp({goal}, {alpha})`

	return ""
end

return Lerp
