local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get User CFrame", "GetUserCFrame", 
	{ { name = "Type", default = "Enum.UserCFrame.Head" } }, 
	{ { name = "Result", default = "CFrame.new()" } })
