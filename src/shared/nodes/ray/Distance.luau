local RayMethod = require(script.Parent.RayMethod)

return RayMethod.create(
	"Ray Distance",
	"Distance",
	{
		{ name = "Point", default = "Vector3.new(0, 0, 0)" }
	},
	"0"
)
