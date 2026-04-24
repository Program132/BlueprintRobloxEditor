local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Cancel = {}
Cancel.__index = Cancel
setmetatable(Cancel, Node)

function Cancel.new()
	local self = Node.new("Task Cancel", NodeType.METHOD)
	setmetatable(self, Cancel)
	self:editColor(Color3.fromRGB(200, 100, 50))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Thread", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	return self
end

function Cancel:toLuau()
	local t = self:getInput("Thread").Value
	return `task.cancel({t})\n`
end

return Cancel
