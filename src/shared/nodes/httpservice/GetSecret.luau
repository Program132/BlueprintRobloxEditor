local Helper = require(script.Parent.HttpServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetSecret", {
	{ name = "Key", default = "''" }
}, {{ name = "Secret", default = "nil" }}, NodeType.FUNCTION)
