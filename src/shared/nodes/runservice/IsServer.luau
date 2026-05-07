local Helper = require(script.Parent.RunServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsServer", {}, {{ name = "IsServer", default = "false" }}, NodeType.FUNCTION)
