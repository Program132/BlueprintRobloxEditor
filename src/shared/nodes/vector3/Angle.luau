local Vector3Method = require(script.Parent.Vector3Method)
return Vector3Method.create("Vector3 Angle", "Angle", {
	{ name = "Other", default = "Vector3.new(1, 0, 0)" },
	{ name = "Axis", default = "Vector3.new(0, 1, 0)" }
}, "0")
