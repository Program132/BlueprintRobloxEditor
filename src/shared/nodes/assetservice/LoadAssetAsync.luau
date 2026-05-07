local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("LoadAssetAsync", {
	{ name = "AssetId", default = "0" }
}, {{ name = "Asset", default = "nil" }})
