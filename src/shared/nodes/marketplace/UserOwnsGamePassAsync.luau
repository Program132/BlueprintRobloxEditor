local Shared = script.Parent.Parent.Parent
local Node = require(Shared.Node)
local NodeType = require(Shared.NodeType)
local IO = require(Shared.IO)

local UserOwnsGamePassAsync = {}
UserOwnsGamePassAsync.__index = UserOwnsGamePassAsync
setmetatable(UserOwnsGamePassAsync, Node)

function UserOwnsGamePassAsync.new()
	local self = Node.new("MarketplaceService UserOwnsGamePassAsync", NodeType.FUNCTION)
	setmetatable(self, UserOwnsGamePassAsync)
	self:editColor(Color3.fromRGB(255, 170, 0))
	
	self:addInput(IO.Input.new("UserId", "0"))
	self:addInput(IO.Input.new("GamePassId", "0"))
	self:addOutput(IO.Output.new("Owns", "false"))
	
	return self
end

function UserOwnsGamePassAsync:toLuau()
	local userId = self:getInput("UserId").Value or "0"
	local passId = self:getInput("GamePassId").Value or "0"
	self:getOutput("Owns").Value = `game:GetService("MarketplaceService"):UserOwnsGamePassAsync({userId}, {passId})`
	return ""
end

return UserOwnsGamePassAsync

