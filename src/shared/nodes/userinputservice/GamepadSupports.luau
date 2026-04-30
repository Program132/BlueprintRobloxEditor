local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Gamepad Supports", "GamepadSupports", 
	{ { name = "GamepadNum", default = "Enum.UserInputType.Gamepad1" }, { name = "KeyCode", default = "Enum.KeyCode.ButtonA" } }, 
	{ { name = "Result", default = "false" } })
