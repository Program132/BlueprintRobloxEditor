local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Is Navigation Gamepad", "IsNavigationGamepad", 
	{ { name = "GamepadEnum", default = "Enum.UserInputType.Gamepad1" } }, 
	{ { name = "Result", default = "false" } })
