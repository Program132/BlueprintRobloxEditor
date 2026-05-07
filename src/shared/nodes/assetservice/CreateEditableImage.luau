local Helper = require(script.Parent.AssetServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("CreateEditableImage", {
	{ name = "Options", default = "{}" }
}, {{ name = "EditableImage", default = "nil" }}, NodeType.FUNCTION)
