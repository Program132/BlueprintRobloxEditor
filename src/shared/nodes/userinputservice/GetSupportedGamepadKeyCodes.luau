local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get Supported Gamepad KeyCodes", "GetSupportedGamepadKeyCodes", 
	{ { name = "GamepadNum", default = "Enum.UserInputType.Gamepad1" } }, 
	{ { name = "Result", default = "{}" } })
