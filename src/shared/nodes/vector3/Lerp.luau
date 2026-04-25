local Vector3Method = require(script.Parent.Vector3Method)
return Vector3Method.create("Vector3 Lerp", "Lerp", {
	{ name = "Goal", default = "Vector3.new(0, 0, 0)" },
	{ name = "Alpha", default = "0.5" }
}, "Vector3.new(0, 0, 0)")
