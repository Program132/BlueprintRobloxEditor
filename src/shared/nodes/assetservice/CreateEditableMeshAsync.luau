local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("CreateEditableMeshAsync", {
	{ name = "Content", default = "''" },
	{ name = "Options", default = "{}" }
}, {{ name = "EditableMesh", default = "nil" }})
