local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)

return Helper.create("GetPartsInPart", {
	{ name = "Part", default = "nil" },
	{ name = "Params", default = "nil" }
}, {
	{ name = "Parts", default = "{}" }
}, NodeType.FUNCTION)
