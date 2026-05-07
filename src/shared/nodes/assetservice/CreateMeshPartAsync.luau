local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("CreateMeshPartAsync", {
	{ name = "MeshContent", default = "''" },
	{ name = "Options", default = "{}" }
}, {{ name = "MeshPart", default = "nil" }})
