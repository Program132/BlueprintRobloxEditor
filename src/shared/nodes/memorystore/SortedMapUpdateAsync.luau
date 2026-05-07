local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("SortedMap", "UpdateAsync", {
	{ name = "Key", default = "''" },
	{ name = "TransformFunction", default = "nil" },
	{ name = "Expiration", default = "86400" }
}, {
	{ name = "Value", default = "nil" },
	{ name = "Metadata", default = "nil" }
})
