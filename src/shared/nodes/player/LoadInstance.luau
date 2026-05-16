local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local LoadInstance = {}
LoadInstance.__index = LoadInstance
setmetatable(LoadInstance, Node)

function LoadInstance.new()
	local self = Node.new("Player LoadInstance", NodeType.FUNCTION)
	setmetatable(self, LoadInstance)
	self:editTitle("Load Instance")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil"))
	self:addInput(IO.Input.new("Key", "\"Data\""))
	self:addOutput(IO.Output.new("Result", "nil"))

	return self
end

function LoadInstance:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local key = self:getInput("Key").Value or "\"\""
	local resultVar = "loadedInst_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:LoadInstance({key})\n`
end

return LoadInstance
