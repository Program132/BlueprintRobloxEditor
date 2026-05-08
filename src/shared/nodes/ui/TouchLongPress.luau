local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("TouchLongPress", {
	{ name = "touchPositions", default = "{}" },
	{ name = "state", default = "Enum.UserInputState.Begin" }
})
