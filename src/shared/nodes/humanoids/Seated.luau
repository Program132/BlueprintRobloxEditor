local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("Seated", {
	{ name = "active", default = "false" },
	{ name = "currentSeatPart", default = "nil" }
})
