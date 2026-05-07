local Helper = require(script.Parent.HttpServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("UrlEncode", {
	{ name = "Input", default = "''" }
}, {{ name = "Encoded", default = "''" }}, NodeType.FUNCTION)
