local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local PromptExperienceDetailsAsync = {}
PromptExperienceDetailsAsync.__index = PromptExperienceDetailsAsync
setmetatable(PromptExperienceDetailsAsync, Node)

function PromptExperienceDetailsAsync.new()
	local self = Node.new("TeleportService PromptExperienceDetailsAsync", NodeType.METHOD)
	setmetatable(self, PromptExperienceDetailsAsync)
	self:editColor(Color3.fromRGB(0, 150, 150))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Player", "nil"))
	self:addInput(IO.Input.new("UniverseId", "0"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Result", "Enum.PromptExperienceDetailsResult.Success"))
	
	return self
end

function PromptExperienceDetailsAsync:toLuau()
	local player = self:getInput("Player").Value or "nil"
	local universeId = self:getInput("UniverseId").Value or "0"
	local resVar = `result_{self.Id:gsub("-", "_")}`
	
	self:getOutput("Result").Value = resVar
	
	return `local {resVar} = game:GetService("TeleportService"):PromptExperienceDetailsAsync({player}, {universeId})\n`
end

return PromptExperienceDetailsAsync
