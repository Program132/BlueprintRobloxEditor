local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("PointerAction", {
	{ name = "Wheel" },
	{ name = "Pan" },
	{ name = "Pinch" },
	{ name = "GameProcessedEvent" }
})
