local Helper = require(script.Parent.MemoryStoreMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetQueue", {
	{ name = "Name", default = "''" },
	{ name = "InvisibilityTimeout", default = "30" }
}, {{ name = "Queue", default = "nil" }}, NodeType.FUNCTION)
