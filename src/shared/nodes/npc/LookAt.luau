local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local LookAt = {}
LookAt.__index = LookAt
setmetatable(LookAt, Node)

function LookAt.new()
	local self = Node.new("NPC Look At", NodeType.METHOD)
	setmetatable(self, LookAt)
	self:editTitle("Look At")
	self:editColor(Color3.fromRGB(50, 150, 100))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Target", "Vector3.new(0, 0, 0)"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function LookAt:toLuau()
	local target = self:getInput("Target").Value or "Vector3.new(0, 0, 0)"
	return "do\n" ..
		   "\tlocal root = char:FindFirstChild(\"HumanoidRootPart\")\n" ..
		   "\tlocal targetVal = " .. target .. "\n" ..
		   "\tlocal targetPos = (typeof(targetVal) == \"Instance\" and targetVal:IsA(\"BasePart\")) and targetVal.Position or targetVal\n" ..
		   "\tif root and typeof(targetPos) == \"Vector3\" then\n" ..
		   "\t\troot.CFrame = CFrame.lookAt(root.Position, Vector3.new(targetPos.X, root.Position.Y, targetPos.Z))\n" ..
		   "\tend\n" ..
		   "end\n"
end

return LookAt
