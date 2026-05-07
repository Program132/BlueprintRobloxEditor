local Helper = require(script.Parent.RunServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsStudio", {}, {{ name = "IsStudio", default = "false" }}, NodeType.FUNCTION)
