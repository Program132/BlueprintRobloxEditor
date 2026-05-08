local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsFocused", {}, {{ name = "Result", default = "false" }}, NodeType.FUNCTION)
