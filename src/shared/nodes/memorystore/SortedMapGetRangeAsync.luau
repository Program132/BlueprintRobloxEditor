local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("SortedMap", "GetRangeAsync", {
	{ name = "Direction", default = "Enum.SortDirection.Ascending" },
	{ name = "Count", default = "10" },
	{ name = "LowerBound", default = "nil" },
	{ name = "UpperBound", default = "nil" }
}, {{ name = "Items", default = "{}" }})
