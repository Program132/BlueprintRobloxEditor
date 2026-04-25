local Vector2Method = require(script.Parent.Vector2Method)
return Vector2Method.create("Vector2 FuzzyEq", "FuzzyEq", {
	{ name = "Other", default = "Vector2.new(0, 0)" },
	{ name = "Epsilon", default = "0.00001" }
}, "false")
