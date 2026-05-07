local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("SearchAudioAsync", {
	{ name = "SearchParameters", default = "{}" }
}, {{ name = "Pages", default = "nil" }})
