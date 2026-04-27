local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local IO = require(Shared.IO)
local NodeType = require(Shared.NodeType)

local GetVar = {}
GetVar.__index = GetVar
setmetatable(GetVar, Node)

function GetVar.new()
	local self = Node.new("Get Variable", NodeType.VARIABLE)
	setmetatable(self, GetVar)

	self:addInput(IO.Input.new("name", ""))
	self:addOutput(IO.Output.new("value", ""))

	return self
end

function GetVar:toLuau()
	local varName = self:getInput("name").Value
	-- Clean up quotes if user typed them
	if varName:sub(1,1) == "\"" and varName:sub(-1,-1) == "\"" then
		varName = varName:sub(2, -2)
	end
	
	if varName == "" then return "-- Missing variable name" end
	
	-- A Get node just provides its name as the value for the output pin
	self:getOutput("value").Value = "var_" .. varName
	return "" -- Get nodes don't generate standalone code lines, they provide data
end

return GetVar
