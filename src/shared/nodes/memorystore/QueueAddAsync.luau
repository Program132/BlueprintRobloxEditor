local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("Queue", "AddAsync", {
	{ name = "Value", default = "nil" },
	{ name = "Expiration", default = "86400" },
	{ name = "Priority", default = "0" }
}, {})
