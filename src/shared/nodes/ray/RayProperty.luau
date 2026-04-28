local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local RayProperty = {}

function RayProperty.create(name, propertyName, defaultResult)
	local R = {}
	R.__index = R
	setmetatable(R, Node)

	function R.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, R)
		self:editColor(Color3.fromRGB(120, 80, 220)) -- Purple-ish for Ray
		
		self:addInput(IO.Input.new("Ray", ""))
		
		self:addOutput(IO.Output.new("Value", defaultResult or "0"))
		return self
	end

	function R:toLuau()
		local ray = self:getInput("Ray").Value
		self:getOutput("Value").Value = `{ray}.{propertyName}`
		return ""
	end

	return R
end

return RayProperty
