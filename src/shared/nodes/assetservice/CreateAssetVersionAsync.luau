local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("CreateAssetVersionAsync", {
	{ name = "Object", default = "nil" },
	{ name = "AssetType", default = "Enum.AssetType.Image" },
	{ name = "AssetId", default = "0" },
	{ name = "RequestParameters", default = "{}" }
}, {
	{ name = "AssetId", default = "0" },
	{ name = "Status", default = "''" }
})
