local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("TouchSwipe", {
	{ name = "SwipeDirection" },
	{ name = "NumberOfTouches" },
	{ name = "GameProcessedEvent" }
})
