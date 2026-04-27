local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local ScriptGlobal = {}
ScriptGlobal.__index = ScriptGlobal
setmetatable(ScriptGlobal, Node)

function ScriptGlobal.new()
	local self = Node.new("script", NodeType.FUNCTION)
	setmetatable(self, ScriptGlobal)
	self:editColor(Color3.fromRGB(200, 200, 200))

	self:addOutput(IO.Output.new("script", "script"))

	return self
end

function ScriptGlobal:toLuau()
	self:getOutput("script").Value = "script"
	return ""
end

return ScriptGlobal
