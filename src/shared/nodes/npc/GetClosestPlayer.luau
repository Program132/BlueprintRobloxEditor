local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local GetClosestPlayer = {}
GetClosestPlayer.__index = GetClosestPlayer
setmetatable(GetClosestPlayer, Node)

function GetClosestPlayer.new()
	local self = Node.new("NPC Get Closest Player", NodeType.METHOD)
	setmetatable(self, GetClosestPlayer)
	self:editTitle("Get Closest Player")
	self:editColor(Color3.fromRGB(80, 120, 200))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("MaxDistance", "100", false, nil, "number"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Player", "nil"))
	self:addOutput(IO.Output.new("Character", "nil"))
	self:addOutput(IO.Output.new("Distance", "9999", false, nil, "number"))

	return self
end

function GetClosestPlayer:toLuau()
	local maxDist = self:getInput("MaxDistance").Value or "100"
	local varPlayer = "closestPlr_" .. self.Id:gsub("-", "")
	local varChar = "closestChar_" .. self.Id:gsub("-", "")
	local varDist = "closestDist_" .. self.Id:gsub("-", "")
	
	self:getOutput("Player").Value = varPlayer
	self:getOutput("Character").Value = varChar
	self:getOutput("Distance").Value = varDist
	
	return "local " .. varPlayer .. ", " .. varChar .. ", " .. varDist .. " = nil, nil, " .. maxDist .. "\n" ..
		   "do\n" ..
		   "\tlocal myPos = char.PrimaryPart and char.PrimaryPart.Position or char:GetPivot().Position\n" ..
		   "\tfor _, plr in ipairs(Players:GetPlayers()) do\n" ..
		   "\t\tlocal pChar = plr.Character\n" ..
		   "\t\tlocal root = pChar and pChar:FindFirstChild(\"HumanoidRootPart\")\n" ..
		   "\t\tif root then\n" ..
		   "\t\t\tlocal d = (root.Position - myPos).Magnitude\n" ..
		   "\t\t\tif d < " .. varDist .. " then\n" ..
		   "\t\t\t\t" .. varDist .. " = d\n" ..
		   "\t\t\t\t" .. varPlayer .. " = plr\n" ..
		   "\t\t\t\t" .. varChar .. " = pChar\n" ..
		   "\t\t\tend\n" ..
		   "\t\tend\n" ..
		   "\tend\n" ..
		   "end\n"
end

return GetClosestPlayer
