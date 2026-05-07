local Helper = require(script.Parent.RunServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsEdit", {}, {{ name = "IsEdit", default = "false" }}, NodeType.FUNCTION)
