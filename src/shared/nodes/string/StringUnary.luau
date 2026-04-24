local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local StringUnary = {}

function StringUnary.create(name, funcName)
	local S = {}
	S.__index = S
	setmetatable(S, Node)

	function S.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, S)
		self:editColor(Color3.fromRGB(180, 70, 70)) -- Reddish for strings
		self:addInput(IO.Input.new("String", '""'))
		self:addOutput(IO.Output.new("Result", '""'))
		return self
	end

	function S:toLuau()
		local s = self:getInput("String").Value
		self:getOutput("Result").Value = `string.{funcName}({s})`
		return ""
	end

	return S
end

return StringUnary
