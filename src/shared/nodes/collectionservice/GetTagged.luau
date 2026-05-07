local Helper = require(script.Parent.CollectionServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetTagged", {
	{ name = "Tag", default = "'Tag'" }
}, {{ name = "Instances", default = "{}" }}, NodeType.FUNCTION)
