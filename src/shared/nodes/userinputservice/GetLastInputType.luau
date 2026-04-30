local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get Last Input Type", "GetLastInputType", {}, { { name = "Result", default = "Enum.UserInputType.None" } })
