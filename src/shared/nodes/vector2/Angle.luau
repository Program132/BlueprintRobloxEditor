local Vector2Method = require(script.Parent.Vector2Method)
return Vector2Method.create("Vector2 Angle", "Angle", {
	{ name = "Other", default = "Vector2.new(1, 0)" },
	{ name = "IsSigned", default = "false" }
}, "0")
