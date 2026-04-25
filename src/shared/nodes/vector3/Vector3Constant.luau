local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Vector3Constant = {}

function Vector3Constant.create(name, propertyName)
	local V = {}
	V.__index = V
	setmetatable(V, Node)

	function V.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, V)
		self:editColor(Color3.fromRGB(50, 100, 240))
		
		self:addOutput(IO.Output.new("Vector", `Vector3.{propertyName}`))
		return self
	end

	function V:toLuau()
		self:getOutput("Vector").Value = `Vector3.{propertyName}`
		return ""
	end

	return V
end

return Vector3Constant
