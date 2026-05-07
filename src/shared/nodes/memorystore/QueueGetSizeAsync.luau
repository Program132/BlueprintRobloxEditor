local Helper = require(script.Parent.MemoryStoreObjectMethod)
return Helper.create("Queue", "GetSizeAsync", {{ name = "ExcludeInvisible", default = "false" }}, {{ name = "Size", default = "0" }})
