local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local InstanceToAssetServiceNode = {}
InstanceToAssetServiceNode.__index = InstanceToAssetServiceNode
setmetatable(InstanceToAssetServiceNode, Node)

function InstanceToAssetServiceNode.new()
	local self = Node.new("Instance to AssetService", NodeType.FUNCTION)
	setmetatable(self, InstanceToAssetServiceNode)
	self:editColor(Color3.fromRGB(150, 100, 255))
	
	self:addInput(IO.Input.new("Instance", "nil"))
	
	-- Custom properties
	self:addOutput(IO.Output.new("AllowInsertFreeAssets", "false"))
	
	-- Base instance properties
	self:addOutput(IO.Output.new("Archivable", "true"))
	self:addOutput(IO.Output.new("Capabilities", "nil"))
	self:addOutput(IO.Output.new("Name", "''"))
	self:addOutput(IO.Output.new("Parent", "nil"))
	self:addOutput(IO.Output.new("PredictionMode", "Enum.PredictionMode.Default"))
	self:addOutput(IO.Output.new("Sandboxed", "false"))
	self:addOutput(IO.Output.new("UniqueId", "''"))
	
	return self
end

function InstanceToAssetServiceNode:toLuau()
	local inst = self:getInput("Instance").Value or "nil"
	
	self:getOutput("AllowInsertFreeAssets").Value = `{inst}.AllowInsertFreeAssets`
	
	self:getOutput("Archivable").Value = `{inst}.Archivable`
	self:getOutput("Capabilities").Value = `{inst}.Capabilities`
	self:getOutput("Name").Value = `{inst}.Name`
	self:getOutput("Parent").Value = `{inst}.Parent`
	self:getOutput("PredictionMode").Value = `{inst}.PredictionMode`
	self:getOutput("Sandboxed").Value = `{inst}.Sandboxed`
	self:getOutput("UniqueId").Value = `{inst}.UniqueId`
	
	return ""
end

return InstanceToAssetServiceNode
