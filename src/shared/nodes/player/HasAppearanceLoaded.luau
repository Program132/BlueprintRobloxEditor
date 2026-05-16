local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local HasAppearanceLoaded = {}
HasAppearanceLoaded.__index = HasAppearanceLoaded
setmetatable(HasAppearanceLoaded, Node)

function HasAppearanceLoaded.new()
	local self = Node.new("Player HasAppearanceLoaded", NodeType.FUNCTION)
	setmetatable(self, HasAppearanceLoaded)
	self:editTitle("Has Appearance Loaded")
	self:editColor(Color3.fromRGB(0, 162, 255))

	self:addInput(IO.Input.new("Instance", "nil", false, nil, "Player"))
	self:addOutput(IO.Output.new("Result", "false", false, nil, "boolean"))

	return self
end

function HasAppearanceLoaded:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	local resultVar = "loaded_" .. self.Id:gsub("-", ""):sub(1, 4)
	self:getOutput("Result").Value = resultVar
	return `local {resultVar} = {inst}:HasAppearanceLoaded()\n`
end

return HasAppearanceLoaded
