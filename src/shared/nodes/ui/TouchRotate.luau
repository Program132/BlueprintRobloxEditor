local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("TouchRotate", {
	{ name = "touchPositions", default = "{}" },
	{ name = "rotation", default = "0" },
	{ name = "velocity", default = "0" },
	{ name = "state", default = "Enum.UserInputState.Begin" }
})
