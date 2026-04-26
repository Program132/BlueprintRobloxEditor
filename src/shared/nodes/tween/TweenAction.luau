local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local TweenAction = {}

function TweenAction.create(name, funcName)
	local T = {}
	T.__index = T
	setmetatable(T, Node)

	function T.new()
		local self = Node.new(name, NodeType.METHOD)
		setmetatable(self, T)
		self:editColor(Color3.fromRGB(255, 100, 150))
		
		self:addInput(IO.Input.new("Exec", ""))
		self:addInput(IO.Input.new("Tween", "nil"))
		
		self:addOutput(IO.Output.new("Exec", ""))
		return self
	end

	function T:toLuau()
		local tween = self:getInput("Tween").Value
		return `{tween}:{funcName}()\n`
	end

	return T
end

return TweenAction
