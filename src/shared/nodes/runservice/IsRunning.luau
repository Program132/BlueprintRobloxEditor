local Helper = require(script.Parent.RunServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsRunning", {}, {{ name = "IsRunning", default = "false" }}, NodeType.FUNCTION)
