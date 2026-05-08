local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)

return Helper.create("Blockcast", {
	{ name = "CFrame", default = "CFrame.new()" },
	{ name = "Size", default = "Vector3.new(1, 1, 1)" },
	{ name = "Direction", default = "Vector3.new(0, 0, 0)" },
	{ name = "Params", default = "nil" }
}, {
	{ name = "Result", default = "nil" }
}, NodeType.FUNCTION)
