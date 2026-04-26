local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local WorkspaceObject = {}
WorkspaceObject.__index = WorkspaceObject
setmetatable(WorkspaceObject, Node)

function WorkspaceObject.new()
	local self = Node.new("Workspace Object", NodeType.FUNCTION)
	setmetatable(self, WorkspaceObject)
	self:editColor(Color3.fromRGB(100, 180, 255))

	self:addInput(IO.Input.new("Path", "BasePart"))

	self:addOutput(IO.Output.new("Instance", "workspace.BasePart"))

	return self
end

function WorkspaceObject:toLuau()
	local pathInput = self:getInput("Path").Value
	-- Strip quotes if the user provided them
	local path = pathInput:gsub('^"(.*)"$', "%1")
	
	self:getOutput("Instance").Value = `workspace.{path}`

	return ""
end

return WorkspaceObject
