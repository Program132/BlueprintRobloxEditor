local Helper = require(script.Parent.HttpServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("JSONEncode", {
	{ name = "Input", default = "{}" }
}, {{ name = "JSON", default = "''" }}, NodeType.FUNCTION)
