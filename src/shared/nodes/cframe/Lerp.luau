local CFrameMethod = require(script.Parent.CFrameMethod)
return CFrameMethod.create("CFrame Lerp", "Lerp", {
	{ name = "Goal", default = "CFrame.identity" },
	{ name = "Alpha", default = "0.5" }
}, "CFrame.identity")
