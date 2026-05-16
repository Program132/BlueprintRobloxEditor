local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local LoadCharacterAsync = {}
LoadCharacterAsync.__index = LoadCharacterAsync
setmetatable(LoadCharacterAsync, Node)

function LoadCharacterAsync.new()
	local self = Node.new("Player LoadCharacterAsync", NodeType.METHOD)
	setmetatable(self, LoadCharacterAsync)
	self:editTitle("Load Character (Async)")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function LoadCharacterAsync:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	return `{inst}:LoadCharacterAsync()\n`
end

return LoadCharacterAsync
