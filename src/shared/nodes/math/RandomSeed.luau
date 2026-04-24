local Node = require(script.Parent.Parent.Parent.Node)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
local IO = require(script.Parent.Parent.Parent.IO)

local RandomSeed = {}
RandomSeed.__index = RandomSeed
setmetatable(RandomSeed, Node)

function RandomSeed.new()
	local self = Node.new("Random Seed", NodeType.METHOD)
	setmetatable(self, RandomSeed)
	self:editColor(Color3.fromRGB(40, 150, 70))
	self:addInput(IO.Input.new("Exec", ""))
	self:addInput(IO.Input.new("Seed", "0"))
	self:addOutput(IO.Output.new("Exec", ""))
	return self
end

function RandomSeed:toLuau()
	local seed = self:getInput("Seed").Value
	return `math.randomseed({seed})\n`
end

return RandomSeed
