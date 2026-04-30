local UserInputServiceMethod = require(script.Parent.UserInputServiceMethod)
return UserInputServiceMethod.create("Get Device Rotation", "GetDeviceRotation", {}, { { name = "Rotation", default = "nil" }, { name = "CFrame", default = "CFrame.new()" } })
