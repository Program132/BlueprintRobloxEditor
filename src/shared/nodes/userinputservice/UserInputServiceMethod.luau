local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local UserInputServiceMethod = {}

function UserInputServiceMethod.create(name, funcName, inputs, outputs)
	local M = {}
	M.__index = M
	setmetatable(M, Node)

	function M.new()
		local self = Node.new(name, NodeType.FUNCTION)
		setmetatable(self, M)
		self:editColor(Color3.fromRGB(0, 180, 200))
		
		for _, inp in ipairs(inputs or {}) do
			self:addInput(IO.Input.new(inp.name, inp.default or '""'))
		end
		
		if not outputs or #outputs == 0 then
			self:addOutput(IO.Output.new("Result", "nil"))
		else
			for _, out in ipairs(outputs) do
				self:addOutput(IO.Output.new(out.name, out.default or "nil"))
			end
		end
		
		return self
	end

	function M:toLuau()
		local args = {}
		for _, inp in ipairs(inputs or {}) do
			table.insert(args, self:getInput(inp.name).Value)
		end
		
		local argsStr = table.concat(args, ", ")
		local call = `game:GetService("UserInputService"):{funcName}({argsStr})`
		
		if not outputs or #outputs <= 1 then
			local outName = (outputs and outputs[1] and outputs[1].name) or "Result"
			self:getOutput(outName).Value = call
		else
			-- For tuples, we just assign the whole call to the first output for now
			-- Luau handles this if it's the last expression in an assignment or passed to a function
			-- But for our graph, we'd need better multi-return support.
			self:getOutput(outputs[1].name).Value = call
		end
		
		return ""
	end

	return M
end

return UserInputServiceMethod
