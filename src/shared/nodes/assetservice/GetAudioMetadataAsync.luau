local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("GetAudioMetadataAsync", {
	{ name = "IdList", default = "{}" }
}, {{ name = "Metadata", default = "{}" }})
