local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local EquipTool = {}
EquipTool.__index = EquipTool
setmetatable(EquipTool, Node)

function EquipTool.new()
	local self = Node.new("NPC Equip Tool", NodeType.METHOD)
	setmetatable(self, EquipTool)
	self:editTitle("Equip Tool")
	self:editColor(Color3.fromRGB(180, 100, 50))

	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Tool", "nil", false, nil, "Instance"))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function EquipTool:toLuau()
	local tool = self:getInput("Tool").Value or "nil"
	return "if " .. tool .. " then humanoid:EquipTool(" .. tool .. ") end\n"
end

return EquipTool
