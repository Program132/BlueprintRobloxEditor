local Helper = require(script.Parent.HttpServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("JSONDecode", {
	{ name = "JSON", default = "'{}'" }
}, {{ name = "Value", default = "nil" }}, NodeType.FUNCTION)
