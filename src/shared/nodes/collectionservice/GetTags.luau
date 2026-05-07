local Helper = require(script.Parent.CollectionServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetTags", {
	{ name = "Instance", default = "nil" }
}, {{ name = "Tags", default = "{}" }}, NodeType.FUNCTION)
