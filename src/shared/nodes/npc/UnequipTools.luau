local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local UnequipTools = {}
UnequipTools.__index = UnequipTools
setmetatable(UnequipTools, Node)

function UnequipTools.new()
	local self = Node.new("NPC Unequip Tools", NodeType.METHOD)
	setmetatable(self, UnequipTools)
	self:editTitle("Unequip Tools")
	self:editColor(Color3.fromRGB(180, 100, 50))

	self:addInput(IO.Input.new("Exec", ""))
	
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function UnequipTools:toLuau()
	return "humanoid:UnequipTools()\n"
end

return UnequipTools
