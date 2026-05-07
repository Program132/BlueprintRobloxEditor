local Helper = require(script.Parent.RunServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsRunMode", {}, {{ name = "IsRunMode", default = "false" }}, NodeType.FUNCTION)
