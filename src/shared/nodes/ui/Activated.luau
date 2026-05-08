local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("Activated", {
	{ name = "inputObject", default = "nil" },
	{ name = "clickCount", default = "0" }
})
