local Helper = require(script.Parent.RunServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsClient", {}, {{ name = "IsClient", default = "false" }}, NodeType.FUNCTION)
