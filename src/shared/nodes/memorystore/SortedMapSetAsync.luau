local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("SortedMap", "SetAsync", {
	{ name = "Key", default = "''" },
	{ name = "Value", default = "nil" },
	{ name = "Expiration", default = "86400" },
	{ name = "SortKey", default = "nil" }
}, {{ name = "Success", default = "false" }})
