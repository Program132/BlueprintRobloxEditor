local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("TouchPinch", {
	{ name = "touchPositions", default = "{}" },
	{ name = "scale", default = "1" },
	{ name = "velocity", default = "0" },
	{ name = "state", default = "Enum.UserInputState.Begin" }
})
