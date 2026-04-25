local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local EnumFunc = {}

function EnumFunc.create(name, enumName, values, defaultValue)
	local E = {}
	E.__index = E
	setmetatable(E, Node)

	function E.new()
		local self = Node.new("Enum " .. name, NodeType.ENUM)
		setmetatable(self, E)
		self:editColor(Color3.fromRGB(150, 150, 40))
		
		self:addInput(IO.Input.new(name, defaultValue or values[1], false, values))
		self:addOutput(IO.Output.new("Enum", `Enum.{enumName}.{defaultValue or values[1]}`))
		
		return self
	end

	function E:toLuau()
		local selected = self:getInput(name).Value
		self:getOutput("Enum").Value = `Enum.{enumName}.{selected}`
		return ""
	end

	return E
end

return EnumFunc
