local Helper = require(script.Parent.MemoryStoreObjectMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("HashMap", "GetAsync", {{ name = "Key", default = "''" }}, {{ name = "Value", default = "nil" }}, NodeType.METHOD)
