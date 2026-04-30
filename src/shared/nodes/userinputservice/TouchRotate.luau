local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("TouchRotate", {
	{ name = "TouchPositions" },
	{ name = "Rotation" },
	{ name = "Velocity" },
	{ name = "State" },
	{ name = "GameProcessedEvent" }
})
