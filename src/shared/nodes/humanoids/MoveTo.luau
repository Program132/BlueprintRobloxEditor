local Helper = require(script.Parent.Parent.MethodHelper)
return Helper.create("MoveTo", {
	{ name = "location", default = "Vector3.new(0, 0, 0)" },
	{ name = "part", default = "nil" }
})
