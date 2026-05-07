local Helper = require(script.Parent.HttpServiceMethod)
return Helper.create("PostAsync", {
	{ name = "Url", default = "'https://google.com'" },
	{ name = "Data", default = "''" },
	{ name = "ContentType", default = "Enum.HttpContentType.ApplicationJson" },
	{ name = "Compress", default = "false" },
	{ name = "Headers", default = "nil" }
}, {{ name = "Result", default = "''" }})
