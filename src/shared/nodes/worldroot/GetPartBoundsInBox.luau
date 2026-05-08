local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)

return Helper.create("GetPartBoundsInBox", {
	{ name = "CFrame", default = "CFrame.new()" },
	{ name = "Size", default = "Vector3.new(1, 1, 1)" },
	{ name = "Params", default = "nil" }
}, {
	{ name = "Parts", default = "{}" }
}, NodeType.FUNCTION)
