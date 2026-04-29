local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetProperty = {}
GetProperty.__index = GetProperty
setmetatable(GetProperty, Node)

function GetProperty.new()
	local self = Node.new("Get Property", NodeType.FUNCTION)
	setmetatable(self, GetProperty)
	self:editColor(Color3.fromRGB(100, 180, 255))

	self:addInput(IO.Input.new("Object", "nil"))
	self:addInput(IO.Input.new("Property", '"Name"'))
	self:addOutput(IO.Output.new("Value", "nil"))

	return self
end

function GetProperty:toLuau()
	local obj = self:getInput("Object").Value or "nil"
	local prop = self:getInput("Property").Value or '""'
	
	local cleanProp = prop
	if prop:sub(1,1) == '"' and prop:sub(-1,-1) == '"' then
		local inner = prop:sub(2, -2)
		if inner:match("^[%a_][%w_]*$") then
			self:getOutput("Value").Value = `{obj}.{inner}`
			return ""
		end
	end

	self:getOutput("Value").Value = `{obj}[{prop}]`
	return ""
end

return GetProperty
