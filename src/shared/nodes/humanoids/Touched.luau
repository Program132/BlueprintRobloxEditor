local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("Touched", {
	{ name = "touchingPart", default = "nil" },
	{ name = "humanoidPart", default = "nil" }
})
