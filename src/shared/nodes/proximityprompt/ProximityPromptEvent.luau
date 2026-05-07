local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local ProximityPromptEvent = {}
ProximityPromptEvent.__index = ProximityPromptEvent
setmetatable(ProximityPromptEvent, Node)

function ProximityPromptEvent.create(eventName, outputs)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, ProximityPromptEvent)
	
	function CustomNode.new()
		local self = Node.new(`ProximityPrompt {eventName}`, NodeType.EVENT)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(255, 130, 80))
		
		self:addInput(IO.Input.new("Prompt", "nil"))
		self:addOutput(IO.Output.new("Exec", ""))
		
		for _, out in ipairs(outputs or {}) do
			self:addOutput(IO.Output.new(out.name, out.default or "nil"))
		end
		
		return self
	end
	
	function CustomNode:toLuau(block, visited, indentCode)
		local prompt = self:getInput("Prompt").Value or "nil"
		local argVars = {}
		for _, out in ipairs(outputs or {}) do
			local varName = out.varName or (string.lower(out.name:sub(1, 1)) .. out.name:sub(2))
			self:getOutput(out.name).Value = varName
			table.insert(argVars, varName)
		end
		
		local body = block:run_from_port(self, "Exec", visited)
		local argStr = table.concat(argVars, ", ")
		
		return `{prompt}.{eventName}:Connect(function({argStr})\n` .. indentCode(body) .. "end)\n"
	end
	
	return CustomNode
end

return ProximityPromptEvent
