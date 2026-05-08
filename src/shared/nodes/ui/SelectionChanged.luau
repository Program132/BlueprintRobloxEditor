local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("SelectionChanged", {
	{ name = "amISelected", default = "false" },
	{ name = "previousSelection", default = "nil" },
	{ name = "newSelection", default = "nil" }
})
