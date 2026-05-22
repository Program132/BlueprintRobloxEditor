local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local PathfindTo = {}
PathfindTo.__index = PathfindTo
setmetatable(PathfindTo, Node)

function PathfindTo.new()
	local self = Node.new("NPC Pathfind To", NodeType.METHOD)
	setmetatable(self, PathfindTo)
	self:editTitle("Pathfind To")
	self:editColor(Color3.fromRGB(50, 150, 100))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Position", "Vector3.new(0, 0, 0)", false, nil, "Vector3"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function PathfindTo:toLuau()
	local pos = self:getInput("Position").Value or "Vector3.new(0, 0, 0)"
	return "do\n" ..
		   "\tlocal path = PathfindingService:CreatePath()\n" ..
		   "\tpath:ComputeAsync(char.PrimaryPart and char.PrimaryPart.Position or char:GetPivot().Position, " .. pos .. ")\n" ..
		   "\tif path.Status == Enum.PathStatus.Success then\n" ..
		   "\t\tfor _, waypoint in ipairs(path:GetWaypoints()) do\n" ..
		   "\t\t\thumanoid:MoveTo(waypoint.Position)\n" ..
		   "\t\t\tif waypoint.Action == Enum.PathWaypointAction.Jump then\n" ..
		   "\t\t\t\thumanoid.Jump = true\n" ..
		   "\t\t\tend\n" ..
		   "\t\t\thumanoid.MoveToFinished:Wait()\n" ..
		   "\t\tend\n" ..
		   "\tend\n" ..
		   "end\n"
end

return PathfindTo
