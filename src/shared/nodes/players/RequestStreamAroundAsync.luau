local Helper = require(script.Parent.PlayerMethod)
return Helper.create("RequestStreamAroundAsync", {
	{ name = "Position", default = "Vector3.new()" },
	{ name = "TimeOut", default = "0" }
}, {})
