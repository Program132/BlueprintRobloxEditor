local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("Queue", "ReadAsync", {
	{ name = "Count", default = "10" },
	{ name = "AllOrNothing", default = "false" },
	{ name = "WaitTimeout", default = "0" }
}, {
	{ name = "Items", default = "{}" },
	{ name = "Id", default = "''" }
})
