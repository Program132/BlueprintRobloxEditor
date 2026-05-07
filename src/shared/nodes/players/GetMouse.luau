local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetMouse", {}, {{ name = "Mouse", default = "nil" }}, NodeType.FUNCTION)
