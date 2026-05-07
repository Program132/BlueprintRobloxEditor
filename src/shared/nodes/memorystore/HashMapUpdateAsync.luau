local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("HashMap", "UpdateAsync", {
	{ name = "Key", default = "''" },
	{ name = "TransformFunction", default = "nil" },
	{ name = "Expiration", default = "86400" }
}, {{ name = "Value", default = "nil" }})
