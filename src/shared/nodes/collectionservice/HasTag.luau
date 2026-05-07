local Helper = require(script.Parent.CollectionServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("HasTag", {
	{ name = "Instance", default = "nil" },
	{ name = "Tag", default = "'Tag'" }
}, {{ name = "HasTag", default = "false" }}, NodeType.FUNCTION)
