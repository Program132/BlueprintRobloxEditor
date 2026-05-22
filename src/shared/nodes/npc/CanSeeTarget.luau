local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local CanSeeTarget = {}
CanSeeTarget.__index = CanSeeTarget
setmetatable(CanSeeTarget, Node)

function CanSeeTarget.new()
	local self = Node.new("NPC Can See Target", NodeType.METHOD)
	setmetatable(self, CanSeeTarget)
	self:editTitle("Can See Target")
	self:editColor(Color3.fromRGB(80, 120, 200))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Target", "nil"))
	self:addInput(IO.Input.new("ObstacleIgnoreList", "{}", false, nil, "table"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("CanSee", "false", false, nil, "boolean"))

	return self
end

function CanSeeTarget:toLuau()
	local target = self:getInput("Target").Value or "nil"
	local ignoreList = self:getInput("ObstacleIgnoreList").Value or "{}"
	local varCanSee = "canSee_" .. self.Id:gsub("-", "")
	self:getOutput("CanSee").Value = varCanSee
	
	return "local " .. varCanSee .. " = false\n" ..
		   "do\n" ..
		   "\tlocal targetVal = " .. target .. "\n" ..
		   "\tlocal targetPos = (typeof(targetVal) == \"Instance\" and targetVal:IsA(\"BasePart\")) and targetVal.Position or targetVal\n" ..
		   "\tlocal origin = char.PrimaryPart and char.PrimaryPart.Position or char:GetPivot().Position\n" ..
		   "\tif typeof(targetPos) == \"Vector3\" then\n" ..
		   "\t\tlocal params = RaycastParams.new()\n" ..
		   "\t\tparams.FilterType = Enum.RaycastFilterType.Exclude\n" ..
		   "\t\tlocal ignore = {char}\n" ..
		   "\t\tif typeof(" .. ignoreList .. ") == \"table\" then\n" ..
		   "\t\t\tfor _, item in ipairs(" .. ignoreList .. ") do table.insert(ignore, item) end\n" ..
		   "\t\tend\n" ..
		   "\t\tparams.FilterDescendantsInstances = ignore\n" ..
		   "\t\tlocal dir = (targetPos - origin)\n" ..
		   "\t\tlocal result = workspace:Raycast(origin, dir, params)\n" ..
		   "\t\tif not result then\n" ..
		   "\t\t\t" .. varCanSee .. " = true\n" ..
		   "\t\telseif typeof(targetVal) == \"Instance\" and (result.Instance:IsAncestorOf(targetVal) or result.Instance == targetVal) then\n" ..
		   "\t\t\t" .. varCanSee .. " = true\n" ..
		   "\t\tend\n" ..
		   "\tend\n" ..
		   "end\n"
end

return CanSeeTarget
