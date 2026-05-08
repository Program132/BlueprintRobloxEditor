local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local Behaviors = { "WhenScrollable", "Always", "Never" }

local ElasticBehaviorNode = {}
ElasticBehaviorNode.__index = ElasticBehaviorNode
setmetatable(ElasticBehaviorNode, Node)

function ElasticBehaviorNode.new()
	local self = Node.new("Enum ElasticBehavior", NodeType.ENUM)
	setmetatable(self, ElasticBehaviorNode)
	self:editColor(Color3.fromRGB(150, 150, 40))
	
	self:addInput(IO.Input.new("Behavior", "WhenScrollable", false, Behaviors))
	self:addOutput(IO.Output.new("Enum", "Enum.ElasticBehavior.WhenScrollable"))
	
	return self
end

function ElasticBehaviorNode:toLuau()
	local selected = self:getInput("Behavior").Value
	self:getOutput("Enum").Value = `Enum.ElasticBehavior.{selected}`
	return ""
end

return ElasticBehaviorNode
