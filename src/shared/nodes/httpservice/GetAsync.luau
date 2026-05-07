local Helper = require(script.Parent.HttpServiceMethod)
return Helper.create("GetAsync", {
	{ name = "Url", default = "'https://google.com'" },
	{ name = "NoCache", default = "false" },
	{ name = "Headers", default = "nil" }
}, {{ name = "Result", default = "''" }})
