local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local WorkspaceGlobal = {}
WorkspaceGlobal.__index = WorkspaceGlobal
setmetatable(WorkspaceGlobal, Node)

function WorkspaceGlobal.new()
	local self = Node.new("workspace", NodeType.FUNCTION)
	setmetatable(self, WorkspaceGlobal)
	self:editColor(Color3.fromRGB(200, 200, 200))

	self:addOutput(IO.Output.new("workspace", "workspace"))

	return self
end

function WorkspaceGlobal:toLuau()
	self:getOutput("workspace").Value = "workspace"
	return ""
end

return WorkspaceGlobal
