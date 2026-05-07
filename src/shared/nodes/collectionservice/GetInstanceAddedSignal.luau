local Helper = require(script.Parent.CollectionServiceEvent)
return Helper.create("GetInstanceAddedSignal", {
	{ name = "Tag", default = "'Tag'" }
}, {
	{ name = "Instance" }
}, true)
