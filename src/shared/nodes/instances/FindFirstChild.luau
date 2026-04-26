local InstanceMethod = require(script.Parent.InstanceMethod)
return InstanceMethod.create("Find First Child", "FindFirstChild", {
	{ name = "Name", default = '"Part"' },
	{ name = "Recursive", default = "false" }
}, "nil")
