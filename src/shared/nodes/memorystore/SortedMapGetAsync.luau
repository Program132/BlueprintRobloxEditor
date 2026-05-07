local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("SortedMap", "GetAsync", {{ name = "Key", default = "''" }}, {
	{ name = "Value", default = "nil" },
	{ name = "Metadata", default = "nil" }
})
