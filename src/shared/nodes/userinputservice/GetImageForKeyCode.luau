local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get Image For KeyCode", "GetImageForKeyCode", 
	{ { name = "KeyCode", default = "Enum.KeyCode.ButtonA" } }, 
	{ { name = "Result", default = '""' } })
