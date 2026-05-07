local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local CollectionServiceEvent = {}
CollectionServiceEvent.__index = CollectionServiceEvent
setmetatable(CollectionServiceEvent, Node)

function CollectionServiceEvent.create(eventName, inputs, outputs, isSignal)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, CollectionServiceEvent)
	
	function CustomNode.new()
		local self = Node.new(`CollectionService {eventName}`, NodeType.EVENT)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(255, 180, 50))
		
		self:addOutput(IO.Output.new("Exec", ""))
		
		for _, inp in ipairs(inputs or {}) do
			self:addInput(IO.Input.new(inp.name, inp.default or ""))
		end
		
		for _, out in ipairs(outputs or {}) do
			self:addOutput(IO.Output.new(out.name, out.default or "nil"))
		end
		
		return self
	end
	
	function CustomNode:toLuau(block, visited, indentCode)
		local argVars = {}
		for _, out in ipairs(outputs or {}) do
			local varName = out.varName or (string.lower(out.name:sub(1, 1)) .. out.name:sub(2))
			self:getOutput(out.name).Value = varName
			table.insert(argVars, varName)
		end
		
		local inputVals = {}
		for _, inp in ipairs(inputs or {}) do
			table.insert(inputVals, self:getInput(inp.name).Value or inp.default or "''")
		end
		
		local body = block:run_from_port(self, "Exec", visited)
		local argStr = table.concat(argVars, ", ")
		local inputStr = table.concat(inputVals, ", ")
		
		local connectStr = if isSignal 
			then `game:GetService("CollectionService"):{eventName}({inputStr}):Connect(function({argStr})\n`
			else `game:GetService("CollectionService").{eventName}:Connect(function({argStr})\n`
			
		return connectStr .. indentCode(body) .. "end)\n"
	end
	
	return CustomNode
end

return CollectionServiceEvent
