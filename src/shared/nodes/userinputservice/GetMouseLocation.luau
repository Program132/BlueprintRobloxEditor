local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get Mouse Location", "GetMouseLocation", {}, { { name = "Result", default = "Vector2.new(0,0)" } })
