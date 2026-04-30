local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("InputEnded", {
	{ name = "Input" },
	{ name = "GameProcessedEvent" }
})
