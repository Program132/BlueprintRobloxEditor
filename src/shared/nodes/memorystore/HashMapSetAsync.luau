local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("HashMap", "SetAsync", {
	{ name = "Key", default = "''" },
	{ name = "Value", default = "nil" },
	{ name = "Expiration", default = "86400" }
}, {{ name = "Success", default = "false" }})
