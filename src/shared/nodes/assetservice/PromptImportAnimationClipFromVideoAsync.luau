local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("PromptImportAnimationClipFromVideoAsync", {
	{ name = "Player", default = "nil" },
	{ name = "ProgressCallback", default = "nil" }
}, {
	{ name = "AnimationClip", default = "nil" },
	{ name = "Status", default = "''" }
})
