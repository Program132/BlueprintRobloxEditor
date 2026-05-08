local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local InstanceNew = {}
InstanceNew.__index = InstanceNew
setmetatable(InstanceNew, Node)

function InstanceNew.new()
	local self = Node.new("Instance new", NodeType.ACTION)
	setmetatable(self, InstanceNew)

	self:editColor(Color3.fromRGB(50, 150, 255))
	
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("ClassName", "'Part'"))
	self:addInput(IO.Input.new("Parent", "nil"))
	
	self:addOutput(IO.Output.new("Exec", ""))
	self:addOutput(IO.Output.new("Instance", "nil"))

	return self
end

function InstanceNew:toLuau()
	local className = self:getInput("ClassName").Value or "'Part'"
	local parent = self:getInput("Parent").Value or "nil"
	
	local varName = `created{self.ID:gsub("-", "")}`
	
	local code = ""
	if parent ~= "nil" then
		code = `local {varName} = Instance.new({className}, {parent})\n`
	else
		code = `local {varName} = Instance.new({className})\n`
	end
	
	self:getOutput("Instance").Value = varName
	
	return code
end

return InstanceNew
