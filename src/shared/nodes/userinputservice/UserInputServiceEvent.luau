local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local UserInputServiceEvent = {}
UserInputServiceEvent.__index = UserInputServiceEvent
setmetatable(UserInputServiceEvent, Node)

function UserInputServiceEvent.create(eventName, outputs)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, UserInputServiceEvent)
	
	function CustomNode.new()
		local self = Node.new(`UserInputService {eventName}`, NodeType.EVENT)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(0, 180, 200))
		
		self:addOutput(IO.Output.new("Exec", ""))
		for _, out in ipairs(outputs) do
			self:addOutput(IO.Output.new(out.name, out.default or "nil"))
		end
		
		return self
	end
	
	function CustomNode:toLuau(block, visited, indentCode)
		local args = {}
		for _, out in ipairs(outputs) do
			-- Use the provided name or a lowercase version as the variable name
			local varName = out.varName or (string.lower(out.name:sub(1, 1)) .. out.name:sub(2))
			self:getOutput(out.name).Value = varName
			table.insert(args, varName)
		end
		
		local body = block:run_from_port(self, "Exec", visited)
		local argStr = table.concat(args, ", ")
		
		return `game:GetService("UserInputService").{eventName}:Connect(function({argStr})\n` .. indentCode(body) .. "end)\n"
	end
	
	return CustomNode
end

return UserInputServiceEvent
