local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get String For KeyCode", "GetStringForKeyCode", 
	{ { name = "KeyCode", default = "Enum.KeyCode.ButtonA" } }, 
	{ { name = "Result", default = '""' } })
