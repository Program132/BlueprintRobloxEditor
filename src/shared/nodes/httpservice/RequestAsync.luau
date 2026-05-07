local Helper = require(script.Parent.HttpServiceMethod)
return Helper.create("RequestAsync", {
	{ name = "Options", default = "{ Url = 'https://google.com', Method = 'GET' }" }
}, {{ name = "Response", default = "{}" }})
