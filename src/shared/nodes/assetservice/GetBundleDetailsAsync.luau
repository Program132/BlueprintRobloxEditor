local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("GetBundleDetailsAsync", {
	{ name = "BundleId", default = "0" }
}, {{ name = "Details", default = "{}" }})
