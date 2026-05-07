local Helper = require(script.Parent.PlayerMethod)
return Helper.create("LoadCharacterWithHumanoidDescriptionAsync", {
	{ name = "HumanoidDescription", default = "nil" },
	{ name = "AssetTypeVerification", default = "Enum.AssetTypeVerification.Default" }
}, {})
