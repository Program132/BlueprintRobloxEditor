local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)

return Helper.create("ArePartsTouchingOthers", {
	{ name = "PartList", default = "{}" },
	{ name = "OverlapIgnored", default = "0" }
}, {
	{ name = "Touching", default = "false" }
}, NodeType.FUNCTION)
