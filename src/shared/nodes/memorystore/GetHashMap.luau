local Helper = require(script.Parent.MemoryStoreMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetHashMap", {{ name = "Name", default = "''" }}, {{ name = "HashMap", default = "nil" }}, NodeType.FUNCTION)
