local EnumFunc = require(script.Parent.EnumFunc)

local values = {
	"Linear", "Sine", "Back", "Quad", "Quart", "Quint",
	"Bounce", "Elastic", "Exponential", "Circular", "Cubic"
}

return EnumFunc.create("EasingStyle", "EasingStyle", values, "Quad")
