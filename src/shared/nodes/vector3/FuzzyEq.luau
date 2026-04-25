local Vector3Method = require(script.Parent.Vector3Method)
return Vector3Method.create("Vector3 FuzzyEq", "FuzzyEq", {
	{ name = "Other", default = "Vector3.new(0, 0, 0)" },
	{ name = "Epsilon", default = "0.00001" }
}, "false")
