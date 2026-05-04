local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local Pcall = {}
Pcall.__index = Pcall
setmetatable(Pcall, Node)

function Pcall.new()
	local self = Node.new("pcall", NodeType.CONTROL)
	setmetatable(self, Pcall)
	
	self:addInput(IO.Input.new("Exec", ""))
	
	self:addOutput(IO.Output.new("Body", "", true))
	self:addOutput(IO.Output.new("Completed", "", true))
	self:addOutput(IO.Output.new("Success", "false"))
	self:addOutput(IO.Output.new("ErrorMessage", '""'))
	
	return self
end

function Pcall:toLuau(block, visited, indentCode)
	local idSuffix = self.Id:gsub("-", "_")
	local successVar = `success_{idSuffix}`
	local errorVar = `err_{idSuffix}`
	
	-- Assign variable names to outputs so connected nodes can use them
	self:getOutput("Success").Value = successVar
	self:getOutput("ErrorMessage").Value = errorVar
	
	-- Use the same visited table to prevent duplication
	local bodyCode = block:run_from_port(self, "Body", visited)
	local completedCode = block:run_from_port(self, "Completed", visited)
	
	local code = `local {successVar}, {errorVar} = pcall(function()\n`
	code ..= indentCode(bodyCode)
	code ..= "end)\n"
	code ..= completedCode
	
	return code
end

return Pcall
