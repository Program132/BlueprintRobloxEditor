local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("TouchDrag", {
	{ name = "DragDirection" },
	{ name = "NumberOfTouches" },
	{ name = "GameProcessedEvent" }
})
