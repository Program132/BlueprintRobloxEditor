local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GetCoreGuiEnabled = {}
GetCoreGuiEnabled.__index = GetCoreGuiEnabled
setmetatable(GetCoreGuiEnabled, Node)

function GetCoreGuiEnabled.new()
	local self = Node.new("StarterGui GetCoreGuiEnabled", NodeType.FUNCTION)
	setmetatable(self, GetCoreGuiEnabled)
	self:editColor(Color3.fromRGB(255, 50, 150))
	
	self:addInput(IO.Input.new("CoreGuiType", "Enum.CoreGuiType.All"))
	self:addOutput(IO.Output.new("Enabled", "true"))
	
	return self
end

function GetCoreGuiEnabled:toLuau()
	local coreType = self:getInput("CoreGuiType").Value or "Enum.CoreGuiType.All"
	self:getOutput("Enabled").Value = `game:GetService("StarterGui"):GetCoreGuiEnabled({coreType})`
	return ""
end

return GetCoreGuiEnabled
