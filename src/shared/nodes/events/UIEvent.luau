local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)
local Block = require(script.Parent.Parent.Parent.Block)

local UIEvent = {}
UIEvent.__index = UIEvent
setmetatable(UIEvent, Node)

function UIEvent.new(nameOrData, context)
	local self = Node.new("UIEvent", NodeType.EVENT)
	setmetatable(self, UIEvent)

	local class = "UIEvent:Element:Event"
	if typeof(nameOrData) == "table" and nameOrData.Class then
		class = nameOrData.Class
	elseif typeof(nameOrData) == "string" then
		class = nameOrData
	end

	self.Class = class
	
	local parts = string.split(class, ":")
	local elementName = parts[2] or "Element"
	local eventName = parts[3] or "Event"

	self:editTitle(elementName .. " " .. eventName)
	self:addOutput(IO.Output.new("Exec", ""))

	return self
end

function UIEvent:toLuau(block, visited)
	local parts = string.split(self.Class, ":")
	local elementName = parts[2] or "Element"
	local eventName = parts[3] or "Event"
	local innerCode = block:run_from_port(self, "Exec", visited)
	return elementName .. "." .. eventName .. ":Connect(function()\n" .. Block.indentCode(innerCode) .. "end)"
end

return UIEvent
