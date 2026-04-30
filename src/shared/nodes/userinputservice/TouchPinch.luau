local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("TouchPinch", {
	{ name = "TouchPositions" },
	{ name = "Scale" },
	{ name = "Velocity" },
	{ name = "State" },
	{ name = "GameProcessedEvent" }
})
