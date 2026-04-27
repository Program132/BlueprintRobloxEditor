local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local RemoteReturn = {}
RemoteReturn.__index = RemoteReturn
setmetatable(RemoteReturn, Node)

function RemoteReturn.new()
	local self = Node.new("Remote Return", NodeType.METHOD)
	setmetatable(self, RemoteReturn)
	self:editColor(Color3.fromRGB(255, 120, 0))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Value", ""))
	
	return self
end

function RemoteReturn:toLuau()
	local val = self:getInput("Value").Value
	return `return {val ~= "" and val or "nil"}\n`
end

return RemoteReturn
