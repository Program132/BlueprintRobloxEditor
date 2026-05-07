local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("CreateSurfaceAppearanceAsync", {
	{ name = "Content", default = "{}" }
}, {{ name = "SurfaceAppearance", default = "nil" }})
