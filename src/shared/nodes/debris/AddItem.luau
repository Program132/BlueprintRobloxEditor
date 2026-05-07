local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local AddItem = {}
AddItem.__index = AddItem
setmetatable(AddItem, Node)

function AddItem.new()
	local self = Node.new("Debris AddItem", NodeType.METHOD)
	setmetatable(self, AddItem)
	self:editColor(Color3.fromRGB(200, 50, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Item", "nil"))
	self:addInput(IO.Input.new("Lifetime", "1"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function AddItem:toLuau()
	local item = self:getInput("Item").Value or "nil"
	local lifetime = self:getInput("Lifetime").Value or "1"
	
	return `game:GetService("Debris"):AddItem({item}, {lifetime})\n`
end

return AddItem
