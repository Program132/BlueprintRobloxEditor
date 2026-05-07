local Helper = require(script.Parent.CollectionServiceEvent)
return Helper.create("GetInstanceRemovedSignal", {
	{ name = "Tag", default = "'Tag'" }
}, {
	{ name = "Instance" }
}, true)
