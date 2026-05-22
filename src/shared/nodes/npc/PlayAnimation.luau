local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local PlayAnimation = {}
PlayAnimation.__index = PlayAnimation
setmetatable(PlayAnimation, Node)

function PlayAnimation.new()
	local self = Node.new("NPC Play Animation", NodeType.METHOD)
	setmetatable(self, PlayAnimation)
	self:editTitle("Play Animation")
	self:editColor(Color3.fromRGB(150, 100, 200))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("AnimationId", '"rbxassetid://"', false, nil, "string"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Track", "nil"))

	return self
end

function PlayAnimation:toLuau()
	local animId = self:getInput("AnimationId").Value or '""'
	local varTrackName = "animTrack_" .. self.Id:gsub("-", "")
	self:getOutput("Track").Value = varTrackName
	return "local " .. varTrackName .. " = nil\n" ..
		   "do\n" ..
		   "\tlocal animator = humanoid:FindFirstChildOfClass(\"Animator\") or Instance.new(\"Animator\", humanoid)\n" ..
		   "\tlocal anim = Instance.new(\"Animation\")\n" ..
		   "\tanim.AnimationId = " .. animId .. "\n" ..
		   "\t" .. varTrackName .. " = animator:LoadAnimation(anim)\n" ..
		   "\t" .. varTrackName .. ":Play()\n" ..
		   "end\n"
end

return PlayAnimation
