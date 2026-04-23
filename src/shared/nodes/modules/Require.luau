local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Require = {}
Require.__index = Require
setmetatable(Require, Node)

function Require.new()
	local self = Node.new("Require", NodeType.FUNCTION)
	setmetatable(self, Require)
	
	self:editTitle("Require Module")
	self:editColor(Color3.fromRGB(150, 100, 40))
	
	self:addInput(IO.Input.new("ModulePath", "MyModule"))
	self:addOutput(IO.Output.new("Module", ""))
	
	return self
end

function Require:toLuau()
	local modName = self:getInput("ModulePath").Value
	local varName = "mod_" .. modName:gsub("[^%a%d]", "_")
	
	local code = string.format("local %s = require(script.Parent:WaitForChild(\"%s\"))\n", varName, modName)
	
	self:getOutput("Module").Value = varName
	
	return code
end

return Require
