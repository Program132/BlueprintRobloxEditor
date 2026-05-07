local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("PromptCreateAssetAsync", {
	{ name = "Player", default = "nil" },
	{ name = "Instance", default = "nil" },
	{ name = "AssetType", default = "Enum.AssetType.Image" }
}, {
	{ name = "AssetId", default = "0" },
	{ name = "Status", default = "''" }
})
