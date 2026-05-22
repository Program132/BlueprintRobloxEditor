local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Respawn = {}
Respawn.__index = Respawn
setmetatable(Respawn, Node)

function Respawn.new()
	local self = Node.new("NPC Respawn", NodeType.METHOD)
	setmetatable(self, Respawn)
	self:editTitle("Respawn")
	self:editColor(Color3.fromRGB(50, 150, 100))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Position", "", false, nil, "Vector3"))

	return self
end

function Respawn:toLuau()
	local posInput = self:getInput("Position").Value or ""
	local targetPosCode = ""
	if posInput == "" then
		targetPosCode = "newChar:PivotTo(backup:GetPivot())"
	else
		targetPosCode = "if typeof(" .. posInput .. ") == \"Vector3\" then\n" ..
		                "\t\t\tnewChar:PivotTo(CFrame.new(" .. posInput .. "))\n" ..
		                "\t\telse\n" ..
		                "\t\t\tnewChar:PivotTo(" .. posInput .. ")\n" ..
		                "\t\tend"
	end

	return "do\n" ..
		   "\tlocal backup = game:GetService(\"ServerStorage\"):FindFirstChild(char.Name .. \"_backup\")\n" ..
		   "\tif backup then\n" ..
		   "\t\tlocal newChar = backup:Clone()\n" ..
		   "\t\tnewChar.Name = char.Name\n" ..
		   "\t\tnewChar.Parent = workspace\n" ..
		   "\t\t" .. targetPosCode .. "\n" ..
		   "\t\tchar:Destroy()\n" ..
		   "\telse\n" ..
		   "\t\twarn(\"[NPC Respawn] Cannot respawn: backup template is nil in ServerStorage.\")\n" ..
		   "\tend\n" ..
		   "end\n"
end

return Respawn
