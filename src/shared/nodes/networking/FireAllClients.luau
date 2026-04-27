local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local FireAllClients = {}
FireAllClients.__index = FireAllClients
setmetatable(FireAllClients, Node)

function FireAllClients.new(data)
	local self = Node.new("FireAllClients", NodeType.METHOD)
	setmetatable(self, FireAllClients)
	self:editColor(Color3.fromRGB(255, 120, 0))
	self.AllowDynamicPins = true
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("RemoteEvent", ""))
	
	local count = 0
	if data and data.InputsValues and data.InputsValues.__argsCount then
		count = tonumber(data.InputsValues.__argsCount) or 0
	end
	
	self:addInput(IO.Input.new("__argsCount", tostring(count)))
	
	for i = 1, count do
		self:addInput(IO.Input.new("Arg " .. i, ""))
	end
	
	self:addOutput(IO.Output.new("Exec", ""))
	
	self.OnAddPin.Event:Connect(function()
		local currentCount = tonumber(self:getInput("__argsCount").Value) or 0
		currentCount += 1
		self:getInput("__argsCount").Value = tostring(currentCount)
		self:addInput(IO.Input.new("Arg " .. currentCount, ""))
		self.OnPinsChanged:Fire()
	end)
	
	self.OnRemovePin.Event:Connect(function()
		local currentCount = tonumber(self:getInput("__argsCount").Value) or 0
		if currentCount > 0 then
			self:removeInput("Arg " .. currentCount)
			currentCount -= 1
			self:getInput("__argsCount").Value = tostring(currentCount)
			self.OnPinsChanged:Fire()
		end
	end)
	
	return self
end

function FireAllClients:toLuau()
	local remote = self:getInput("RemoteEvent").Value
	local count = tonumber(self:getInput("__argsCount").Value) or 0
	
	local args = {}
	for i = 1, count do
		local val = self:getInput("Arg " .. i).Value
		if val ~= "" then table.insert(args, val) end
	end
	
	return `{remote}:FireAllClients({table.concat(args, ", ")})\n`
end

return FireAllClients
