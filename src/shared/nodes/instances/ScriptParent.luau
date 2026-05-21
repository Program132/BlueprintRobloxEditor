local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local ScriptParent = {}
ScriptParent.__index = ScriptParent
setmetatable(ScriptParent, Node)

function ScriptParent.new()
	local self = Node.new("Instance Script Parent", NodeType.FUNCTION)
	setmetatable(self, ScriptParent)
	self:editColor(Color3.fromRGB(100, 180, 255))

	self:addOutput(IO.Output.new("Instance", "script.Parent"))

	return self
end

function ScriptParent:toLuau()
	self:getOutput("Instance").Value = "script.Parent"
	return ""
end

return ScriptParent
