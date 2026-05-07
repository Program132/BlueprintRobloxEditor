local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local TextChatServiceEvent = {}
TextChatServiceEvent.__index = TextChatServiceEvent
setmetatable(TextChatServiceEvent, Node)

function TextChatServiceEvent.create(eventName, outputs)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, TextChatServiceEvent)
	
	function CustomNode.new()
		local self = Node.new(`TextChatService {eventName}`, NodeType.EVENT)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(200, 50, 255))
		
		self:addOutput(IO.Output.new("Exec", ""))
		
		for _, out in ipairs(outputs or {}) do
			self:addOutput(IO.Output.new(out.name, out.default or "nil"))
		end
		
		return self
	end
	
	function CustomNode:toLuau()
		local varNames = {}
		for _, out in ipairs(outputs or {}) do
			local varName = string.lower(eventName:sub(1,1)) .. eventName:sub(2) .. out.name
			self:getOutput(out.name).Value = varName
			table.insert(varNames, varName)
		end
		
		local argStr = table.concat(varNames, ", ")
		return `game:GetService("TextChatService").{eventName}:Connect(function({argStr})\n`, "\nend)"
	end
	
	return CustomNode
end

return TextChatServiceEvent
