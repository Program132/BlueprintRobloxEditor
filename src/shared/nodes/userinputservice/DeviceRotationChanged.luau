local Helper = require(script.Parent.UserInputServiceEvent)
return Helper.create("DeviceRotationChanged", {
	{ name = "Rotation" },
	{ name = "CFrame" }
})
