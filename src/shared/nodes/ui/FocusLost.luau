local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("FocusLost", {
	{ name = "enterPressed", default = "false" },
	{ name = "inputThatCausedFocusLoss", default = "nil" }
})
