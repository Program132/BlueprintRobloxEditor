local Helper = require(script.Parent.RunServiceMethod)
return Helper.create("BindToSimulation", {
	{ name = "Callback", default = "function() end" },
	{ name = "Frequency", default = "Enum.StepFrequency.Hz60" },
	{ name = "Priority", default = "0" }
}, {})
