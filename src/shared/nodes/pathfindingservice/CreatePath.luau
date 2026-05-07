local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local CreatePath = {}
CreatePath.__index = CreatePath
setmetatable(CreatePath, Node)

function CreatePath.new()
	local self = Node.new("Pathfinding CreatePath", NodeType.FUNCTION)
	setmetatable(self, CreatePath)
	self:editColor(Color3.fromRGB(50, 200, 100))
	
	self:addInput(IO.Input.new("AgentParameters", "{}"))
	self:addOutput(IO.Output.new("Path", "nil"))
	
	return self
end

function CreatePath:toLuau()
	local params = self:getInput("AgentParameters").Value or "{}"
	self:getOutput("Path").Value = `game:GetService("PathfindingService"):CreatePath({params})`
	return ""
end

return CreatePath
