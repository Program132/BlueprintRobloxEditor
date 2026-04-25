local CFrameMethod = require(script.Parent.CFrameMethod)
return CFrameMethod.create("CFrame ToWorldSpace", "ToWorldSpace", {
	{ name = "Offset", default = "CFrame.identity" }
}, "CFrame.identity")
