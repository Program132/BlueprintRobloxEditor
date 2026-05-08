local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("StateChanged", {
	{ name = "old", default = "Enum.HumanoidStateType.None" },
	{ name = "new", default = "Enum.HumanoidStateType.None" }
})
