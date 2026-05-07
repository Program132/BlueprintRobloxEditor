local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local RunServiceEvent = {}
RunServiceEvent.__index = RunServiceEvent
setmetatable(RunServiceEvent, Node)

function RunServiceEvent.create(eventName, outputs)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, RunServiceEvent)
	
	function CustomNode.new()
		local self = Node.new(`RunService {eventName}`, NodeType.EVENT)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(150, 200, 100))
		
		self:addOutput(IO.Output.new("Exec", ""))
		for _, out in ipairs(outputs or {}) do
			self:addOutput(IO.Output.new(out.name, out.default or "nil"))
		end
		
		return self
	end
	
	function CustomNode:toLuau(block, visited, indentCode)
		local args = {}
		for _, out in ipairs(outputs or {}) do
			local varName = out.varName or (string.lower(out.name:sub(1, 1)) .. out.name:sub(2))
			self:getOutput(out.name).Value = varName
			table.insert(args, varName)
		end
		
		local body = block:run_from_port(self, "Exec", visited)
		local argStr = table.concat(args, ", ")
		
		return `game:GetService("RunService").{eventName}:Connect(function({argStr})\n` .. indentCode(body) .. "end)\n"
	end
	
	return CustomNode
end

return RunServiceEvent
