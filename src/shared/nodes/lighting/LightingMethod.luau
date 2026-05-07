local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local LightingMethod = {}
LightingMethod.__index = LightingMethod
setmetatable(LightingMethod, Node)

function LightingMethod.create(methodName, inputs, outputs, type)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, LightingMethod)
	
	function CustomNode.new()
		local self = Node.new(`Lighting {methodName}`, type or NodeType.METHOD)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(255, 200, 50))
		
		if type ~= NodeType.FUNCTION then
			self:addInput(IO.Input.new("Exec", ""))
			self:addOutput(IO.Output.new("Exec", ""))
		end
		
		for _, inp in ipairs(inputs or {}) do
			self:addInput(IO.Input.new(inp.name, inp.default or "", false, inp.choices))
		end
		
		for _, out in ipairs(outputs or {}) do
			self:addOutput(IO.Output.new(out.name, out.default or "nil"))
		end
		
		return self
	end
	
	function CustomNode:toLuau()
		local args = {}
		for _, inp in ipairs(inputs or {}) do
			table.insert(args, self:getInput(inp.name).Value or inp.default or "nil")
		end
		
		local argStr = table.concat(args, ", ")
		local call = `game:GetService("Lighting"):{methodName}({argStr})`
		
		if type == NodeType.FUNCTION then
			if outputs and #outputs > 0 then
				for i, out in ipairs(outputs) do
					self:getOutput(out.name).Value = if #outputs == 1 then call else `({call})[{i}]`
				end
			end
			return ""
		else
			return call .. "\n"
		end
	end
	
	return CustomNode
end

return LightingMethod
