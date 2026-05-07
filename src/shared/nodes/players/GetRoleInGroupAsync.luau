local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetRoleInGroupAsync", {{ name = "GroupId", default = "0" }}, {{ name = "Role", default = "''" }}, NodeType.FUNCTION)
