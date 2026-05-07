local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsInGroupAsync", {{ name = "GroupId", default = "0" }}, {{ name = "IsInGroup", default = "false" }}, NodeType.FUNCTION)
