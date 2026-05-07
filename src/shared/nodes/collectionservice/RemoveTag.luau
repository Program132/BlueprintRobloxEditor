local Helper = require(script.Parent.CollectionServiceMethod)
return Helper.create("RemoveTag", {
	{ name = "Instance", default = "nil" },
	{ name = "Tag", default = "'Tag'" }
}, {})
