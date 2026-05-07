local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("CreatePlaceAsync", {
	{ name = "PlaceName", default = "''" },
	{ name = "TemplatePlaceID", default = "0" },
	{ name = "Description", default = "''" }
}, {{ name = "PlaceID", default = "0" }})
