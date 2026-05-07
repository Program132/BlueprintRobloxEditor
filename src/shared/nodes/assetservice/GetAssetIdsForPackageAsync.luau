local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("GetAssetIdsForPackageAsync", {
	{ name = "PackageAssetId", default = "0" }
}, {{ name = "AssetIds", default = "{}" }})
