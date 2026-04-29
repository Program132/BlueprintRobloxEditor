local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SetProperty = {}
SetProperty.__index = SetProperty
setmetatable(SetProperty, Node)

function SetProperty.new()
	local self = Node.new("Set Property", NodeType.METHOD)
	setmetatable(self, SetProperty)
	self:editColor(Color3.fromRGB(100, 180, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Object", "nil"))
	self:addInput(IO.Input.new("Property", '"Name"'))
	self:addInput(IO.Input.new("Value", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function SetProperty:toLuau()
	local obj = self:getInput("Object").Value or "nil"
	local prop = self:getInput("Property").Value or '""'
	local val = self:getInput("Value").Value or "nil"
	
	-- Clean access if possible
	if prop:sub(1,1) == '"' and prop:sub(-1,-1) == '"' then
		local inner = prop:sub(2, -2)
		if inner:match("^[%a_][%w_]*$") then
			return `{obj}.{inner} = {val}\n`
		end
	end

	return `{obj}[{prop}] = {val}\n`
end

return SetProperty
