local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local PlayUIAnimation = {}
PlayUIAnimation.__index = PlayUIAnimation
setmetatable(PlayUIAnimation, Node)

function PlayUIAnimation.new(dataOrContext, context)
	local self = Node.new("Play UI Animation", NodeType.METHOD)
	setmetatable(self, PlayUIAnimation)
	self:editColor(Color3.fromRGB(255, 130, 0)) -- Warm orange for tweens

	local animNames = {}
	local actualContext = context
	if typeof(dataOrContext) == "table" and not dataOrContext.Id then
		actualContext = dataOrContext
	end

	if actualContext and actualContext.script and actualContext.script.animations then
		for _, anim in ipairs(actualContext.script.animations) do
			table.insert(animNames, anim.name)
		end
	end

	local defaultAnim = ""
	if #animNames > 0 then
		defaultAnim = animNames[1]
	end

	if typeof(dataOrContext) == "table" and dataOrContext.InputsValues and dataOrContext.InputsValues.AnimationName then
		defaultAnim = dataOrContext.InputsValues.AnimationName
	end

	local defaultDuration = "1"
	if typeof(dataOrContext) == "table" and dataOrContext.InputsValues and dataOrContext.InputsValues.Duration then
		defaultDuration = dataOrContext.InputsValues.Duration
	end

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("AnimationName", defaultAnim, false, animNames))
	self:addInput(IO.Input.new("Duration", defaultDuration))
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function PlayUIAnimation:toLuau()
	local animName = self:getInput("AnimationName").Value or ""
	local duration = self:getInput("Duration").Value or "1"
	if animName ~= "" then
		local safeName = animName:gsub("[^%w_]", "")
		return "PlayAnimation_" .. safeName .. "(" .. duration .. ")\n"
	else
		return "-- No animation selected\n"
	end
end

return PlayUIAnimation
