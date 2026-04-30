local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Is Key Down", "IsKeyDown", 
	{ { name = "KeyCode", default = "Enum.KeyCode.Q" } }, 
	{ { name = "Result", default = "false" } })
