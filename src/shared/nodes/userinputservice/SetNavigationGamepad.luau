local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Set Navigation Gamepad", "SetNavigationGamepad", 
	{ { name = "GamepadEnum", default = "Enum.UserInputType.Gamepad1" }, { name = "Enabled", default = "true" } }, {})
