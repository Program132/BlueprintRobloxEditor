local Helper = require(script.Parent.HttpServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GenerateGUID", {
	{ name = "Wrap", default = "false" }
}, {{ name = "GUID", default = "''" }}, NodeType.FUNCTION)
