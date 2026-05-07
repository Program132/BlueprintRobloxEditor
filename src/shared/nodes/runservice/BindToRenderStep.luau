local Helper = require(script.Parent.RunServiceMethod)
return Helper.create("BindToRenderStep", {
	{ name = "Name", default = "'CameraUpdate'" },
	{ name = "Priority", default = "200" },
	{ name = "Callback", default = "function() end" }
}, {})
