local Helper = require(script.Parent.AssetServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("CreateEditableMesh", {
	{ name = "Options", default = "{}" }
}, {{ name = "EditableMesh", default = "nil" }}, NodeType.FUNCTION)
