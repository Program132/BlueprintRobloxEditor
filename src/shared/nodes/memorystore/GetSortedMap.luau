local Helper = require(script.Parent.MemoryStoreMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetSortedMap", {{ name = "Name", default = "''" }}, {{ name = "SortedMap", default = "nil" }}, NodeType.FUNCTION)
