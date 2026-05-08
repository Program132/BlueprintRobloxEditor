local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("TouchPan", {
	{ name = "touchPositions", default = "{}" },
	{ name = "totalTranslation", default = "Vector2.new(0, 0)" },
	{ name = "velocity", default = "Vector2.new(0, 0)" },
	{ name = "state", default = "Enum.UserInputState.Begin" }
})
