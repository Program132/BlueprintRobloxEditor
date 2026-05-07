local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local SoundServiceMethod = {}
SoundServiceMethod.__index = SoundServiceMethod
setmetatable(SoundServiceMethod, Node)

function SoundServiceMethod.create(methodName, inputs, outputs, type)
	local CustomNode = {}
	CustomNode.__index = CustomNode
	setmetatable(CustomNode, SoundServiceMethod)
	
	function CustomNode.new()
		local self = Node.new(`SoundService {methodName}`, type or NodeType.METHOD)
		setmetatable(self, CustomNode)
		self:editColor(Color3.fromRGB(255, 100, 200))
		
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
		local call = `game:GetService("SoundService"):{methodName}({argStr})`
		
		if type == NodeType.FUNCTION then
			if outputs and #outputs > 0 then
				for i, out in ipairs(outputs) do
					self:getOutput(out.name).Value = if #outputs == 1 then call else `({call})[{i}]`
				end
			end
			return ""
		else
			-- Method call (with Exec)
			if outputs and #outputs > 0 then
				local varNames = {}
				for i, out in ipairs(outputs) do
					local varName = string.lower(methodName:sub(1,1)) .. methodName:sub(2) .. (out.name == "Result" and "" or out.name)
					self:getOutput(out.name).Value = varName
					table.insert(varNames, varName)
				end
				return `local {table.concat(varNames, ", ")} = {call}\n`
			else
				return call .. "\n"
			end
		end
	end
	
	return CustomNode
end

return SoundServiceMethod
