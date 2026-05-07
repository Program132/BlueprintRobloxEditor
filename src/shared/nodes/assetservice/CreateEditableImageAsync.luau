local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("CreateEditableImageAsync", {
	{ name = "Content", default = "''" },
	{ name = "Options", default = "{}" }
}, {{ name = "EditableImage", default = "nil" }})
