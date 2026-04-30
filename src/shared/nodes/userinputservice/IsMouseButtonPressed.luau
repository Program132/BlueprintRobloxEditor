local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Is Mouse Button Pressed", "IsMouseButtonPressed", 
	{ { name = "MouseButton", default = "Enum.UserInputType.MouseButton1" } }, 
	{ { name = "Result", default = "false" } })
