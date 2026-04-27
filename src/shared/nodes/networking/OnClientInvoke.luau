local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local OnClientInvoke = {}
OnClientInvoke.__index = OnClientInvoke
setmetatable(OnClientInvoke, Node)

function OnClientInvoke.new(data)
	local self = Node.new("OnClientInvoke", NodeType.EVENT)
	setmetatable(self, OnClientInvoke)
	self:editColor(Color3.fromRGB(255, 120, 0))
	self.AllowDynamicPins = true
	
	self:addInput(IO.Input.new("RemoteFunction", ""))
	
	local count = 0
	if data and data.InputsValues and data.InputsValues.__argsCount then
		count = tonumber(data.InputsValues.__argsCount) or 0
	end
	
	self:addInput(IO.Input.new("__argsCount", tostring(count)))
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	for i = 1, count do
		self:addOutput(IO.Output.new("Arg " .. i, ""))
	end
	
	self.OnAddPin.Event:Connect(function()
		local currentCount = tonumber(self:getInput("__argsCount").Value) or 0
		currentCount += 1
		self:getInput("__argsCount").Value = tostring(currentCount)
		self:addOutput(IO.Output.new("Arg " .. currentCount, ""))
		self.OnPinsChanged:Fire()
	end)
	
	self.OnRemovePin.Event:Connect(function()
		local currentCount = tonumber(self:getInput("__argsCount").Value) or 0
		if currentCount > 0 then
			self:removeOutput("Arg " .. currentCount)
			currentCount -= 1
			self:getInput("__argsCount").Value = tostring(currentCount)
			self.OnPinsChanged:Fire()
		end
	end)
	
	return self
end

function OnClientInvoke:toLuau(block, visited, indentCode)
	local remote = self:getInput("RemoteFunction").Value
	local count = tonumber(self:getInput("__argsCount").Value) or 0
	
	-- Set output values for connected nodes to use parameter names
	local argNames = {}
	for i = 1, count do
		local name = "arg" .. i
		local out = self:getOutput("Arg " .. i)
		if out then out.Value = name end
		table.insert(argNames, name)
	end
	
	local body = block:run_from_port(self, "Exec", visited)
	
	return `{remote}.OnClientInvoke = function({table.concat(argNames, ", ")})\n` .. indentCode(body) .. "end\n"
end

return OnClientInvoke
