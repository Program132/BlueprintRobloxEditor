local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get Gamepad State", "GetGamepadState", 
	{ { name = "GamepadNum", default = "Enum.UserInputType.Gamepad1" } }, 
	{ { name = "Result", default = "{}" } })
