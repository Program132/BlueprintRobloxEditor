local EnumFunc = require(script.Parent.EnumFunc)

local values = { "In", "Out", "InOut" }

return EnumFunc.create("EasingDirection", "EasingDirection", values, "Out")
