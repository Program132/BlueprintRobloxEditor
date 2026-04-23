local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SetVar = {}
SetVar.__index = SetVar
setmetatable(SetVar, Node)

function SetVar.new()
	local self = Node.new("Set Variable", NodeType.VARIABLE)
	setmetatable(self, SetVar)

	self:addInput(IO.Input.new("Exec", ""))
	self:addOutput(IO.Output.new("Exec", ""))

	self:addInput(IO.Input.new("name", ""))
	self:addInput(IO.Input.new("value", ""))

	return self
end

function SetVar:toLuau()
	local varName = self:getInput("name").Value
	local value = self:getInput("value").Value or "nil"
	
	-- Clean up quotes for the variable name
	if varName:sub(1,1) == "\"" and varName:sub(-1,-1) == "\"" then
		varName = varName:sub(2, -2)
	end

	if varName == "" then return "-- Missing variable name" end

	return string.format("%s = %s", varName, tostring(value))
end

return SetVar
