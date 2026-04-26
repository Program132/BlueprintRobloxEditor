local InstanceMethod = require(script.Parent.InstanceMethod)
return InstanceMethod.create("Wait For Child", "WaitForChild", {
	{ name = "Name", default = '"Part"' },
	{ name = "Timeout", default = "10" }
}, "nil")
