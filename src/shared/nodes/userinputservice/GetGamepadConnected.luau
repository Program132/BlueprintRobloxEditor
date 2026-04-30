local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get Gamepad Connected", "GetGamepadConnected", 
	{ { name = "GamepadNum", default = "Enum.UserInputType.Gamepad1" } }, 
	{ { name = "Result", default = "false" } })
