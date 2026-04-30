local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SetCoreGuiEnabled = {}
SetCoreGuiEnabled.__index = SetCoreGuiEnabled
setmetatable(SetCoreGuiEnabled, Node)

function SetCoreGuiEnabled.new()
	local self = Node.new("StarterGui SetCoreGuiEnabled", NodeType.METHOD)
	setmetatable(self, SetCoreGuiEnabled)
	self:editColor(Color3.fromRGB(255, 50, 150))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("CoreGuiType", "Enum.CoreGuiType.All"))
	self:addInput(IO.Input.new("Enabled", "true"))
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function SetCoreGuiEnabled:toLuau()
	local coreType = self:getInput("CoreGuiType").Value or "Enum.CoreGuiType.All"
	local enabled = self:getInput("Enabled").Value or "true"
	return `game:GetService("StarterGui"):SetCoreGuiEnabled({coreType}, {enabled})\n`
end

return SetCoreGuiEnabled
