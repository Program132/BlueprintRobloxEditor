local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("HashMap", "ListItemsAsync", {{ name = "Count", default = "10" }}, {{ name = "Pages", default = "nil" }})
