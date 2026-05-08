local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("TouchSwipe", {
	{ name = "swipeDirection", default = "Enum.SwipeDirection.Up" },
	{ name = "numberOfTouches", default = "1" }
})
