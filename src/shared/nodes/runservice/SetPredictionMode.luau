local Helper = require(script.Parent.RunServiceMethod)
return Helper.create("SetPredictionMode", {
	{ name = "Context", default = "game.Workspace" },
	{ name = "Mode", default = "Enum.PredictionMode.Automatic" }
}, {})
