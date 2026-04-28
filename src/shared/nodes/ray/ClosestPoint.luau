local RayMethod = require(script.Parent.RayMethod)

return RayMethod.create(
	"Ray ClosestPoint",
	"ClosestPoint",
	{
		{ name = "Point", default = "Vector3.new(0, 0, 0)" }
	},
	"Vector3.new(0, 0, 0)"
)
