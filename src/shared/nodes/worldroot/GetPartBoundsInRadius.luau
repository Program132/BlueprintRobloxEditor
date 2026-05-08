local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)

return Helper.create("GetPartBoundsInRadius", {
	{ name = "Position", default = "Vector3.new(0, 0, 0)" },
	{ name = "Radius", default = "1" },
	{ name = "Params", default = "nil" }
}, {
	{ name = "Parts", default = "{}" }
}, NodeType.FUNCTION)
