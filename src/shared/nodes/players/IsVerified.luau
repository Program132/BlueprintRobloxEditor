local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsVerified", {}, {{ name = "IsVerified", default = "false" }}, NodeType.FUNCTION)
