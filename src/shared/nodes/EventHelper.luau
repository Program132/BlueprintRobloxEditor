local Shared = script.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local GuiEvent = {}
GuiEvent.__index = GuiEvent
setmetatable(GuiEvent, Node)

function GuiEvent.create(eventName, outputs)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, GuiEvent)
	
	function CustomNode.new()
		local self = Node.new(`UI {eventName}`, NodeType.EVENT)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(80, 180, 255))
		
		self:addInput(IO.Input.new("Instance", "nil"))
		self:addOutput(IO.Output.new("Exec", ""))
		
		for _, out in ipairs(outputs or {}) do
			self:addOutput(IO.Output.new(out.name, out.default or "nil"))
		end
		
		return self
	end
	
	function CustomNode:toLuau()
		local inst = self:getInput("Instance").Value or "nil"
		local argList = {}
		for _, out in ipairs(outputs or {}) do
			table.insert(argList, out.name)
			self:getOutput(out.name).Value = out.name
		end
		local args = table.concat(argList, ", ")
		
		return `{inst}.{eventName}:Connect(function({args})\n`, "\nend)"
	end
	
	return CustomNode
end

return GuiEvent
