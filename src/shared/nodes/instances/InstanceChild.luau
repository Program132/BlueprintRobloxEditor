local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local InstanceChild = {}
InstanceChild.__index = InstanceChild
setmetatable(InstanceChild, Node)

function InstanceChild.new()
	local self = Node.new("Instance Child", NodeType.FUNCTION)
	setmetatable(self, InstanceChild)
	self:editColor(Color3.fromRGB(100, 180, 255))

	self:addInput(IO.Input.new("Parent", "workspace"))
	self:addInput(IO.Input.new("Child Name", "BasePart", false, {"BasePart"}))

	self:addOutput(IO.Output.new("Instance", "nil"))

	return self
end

function InstanceChild:Refresh()
	local parentPath = self:getInput("Parent").Value
	
	-- Simple helper to find instance by path string
	local function getInstance(path)
		if path == "workspace" or path == "game.Workspace" then return workspace end
		if path == "game" then return game end
		
		-- Try to follow the path
		local parts = path:split(".")
		local current = nil
		
		if parts[1] == "workspace" then
			current = workspace
			table.remove(parts, 1)
		elseif parts[1] == "game" then
			current = game
			table.remove(parts, 1)
		end
		
		if not current then return nil end
		
		for _, name in ipairs(parts) do
			current = current:FindFirstChild(name)
			if not current then return nil end
		end
		return current
	end

	local parentInstance = getInstance(parentPath)
	if parentInstance then
		local childrenNames = {}
		for _, child in ipairs(parentInstance:GetChildren()) do
			table.insert(childrenNames, child.Name)
		end
		table.sort(childrenNames)
		
		self:getInput("Child Name").Choices = childrenNames
		self.OnPinsChanged:Fire()
	end
end

function InstanceChild:toLuau()
	local parent = self:getInput("Parent").Value
	local childName = self:getInput("Child Name").Value

	local result = `{parent}["{childName}"]`
	self:getOutput("Instance").Value = result

	return ""
end

return InstanceChild
