local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("TouchPan", {
	{ name = "TouchPositions" },
	{ name = "TotalTranslation" },
	{ name = "Velocity" },
	{ name = "State" },
	{ name = "GameProcessedEvent" }
})
