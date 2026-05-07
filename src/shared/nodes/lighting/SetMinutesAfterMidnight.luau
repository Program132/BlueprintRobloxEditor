local Helper = require(script.Parent.LightingMethod)
return Helper.create("SetMinutesAfterMidnight", {
	{ name = "Minutes", default = "720" }
}, {})
