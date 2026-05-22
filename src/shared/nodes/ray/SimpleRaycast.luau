local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local SimpleRaycast = {}
SimpleRaycast.__index = SimpleRaycast
setmetatable(SimpleRaycast, Node)

function SimpleRaycast.new()
	local self = Node.new("Simple Raycast", NodeType.METHOD)
	setmetatable(self, SimpleRaycast)
	self:editColor(Color3.fromRGB(120, 80, 220)) -- Purple color for rays

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Origin", "Vector3.new(0, 0, 0)", false, nil, "Vector3"))
	self:addInput(IO.Input.new("Direction", "Vector3.new(0, -10, 0)", false, nil, "Vector3"))
	self:addInput(IO.Input.new("IgnoreList", "nil", false, nil, "variant"))

	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("HitPart", "nil", false, nil, "Instance"))
	self:addOutput(IO.Output.new("Position", "nil", false, nil, "Vector3"))
	self:addOutput(IO.Output.new("Normal", "nil", false, nil, "Vector3"))
	self:addOutput(IO.Output.new("Material", "nil", false, nil, "Enum.Material"))
	self:addOutput(IO.Output.new("Distance", "0", false, nil, "number"))

	return self
end

function SimpleRaycast:toLuau()
	local origin = self:getInput("Origin").Value or "Vector3.new(0, 0, 0)"
	local direction = self:getInput("Direction").Value or "Vector3.new(0, -10, 0)"
	local ignore = self:getInput("IgnoreList").Value or "nil"

	local suffix = self.Id:gsub("-", ""):sub(1, 4)
	local resultVar = "raycast_" .. suffix
	local paramsVar = "params_" .. suffix

	local code = ""
	local paramsArg = "nil"
	if ignore ~= "nil" and ignore ~= "" then
		code = code .. string.format("local %s = RaycastParams.new()\n", paramsVar)
		code = code .. string.format("%s.FilterDescendantsInstances = typeof(%s) == 'table' and %s or {%s}\n", paramsVar, ignore, ignore, ignore)
		paramsArg = paramsVar
	end

	code = code .. string.format("local %s = workspace:Raycast(%s, %s, %s)\n", resultVar, origin, direction, paramsArg)

	self:getOutput("HitPart").Value = string.format("(%s and %s.Instance)", resultVar, resultVar)
	self:getOutput("Position").Value = string.format("(%s and %s.Position)", resultVar, resultVar)
	self:getOutput("Normal").Value = string.format("(%s and %s.Normal)", resultVar, resultVar)
	self:getOutput("Material").Value = string.format("(%s and %s.Material)", resultVar, resultVar)
	self:getOutput("Distance").Value = string.format("(%s and %s.Distance or 0)", resultVar, resultVar)

	return code
end

return SimpleRaycast
