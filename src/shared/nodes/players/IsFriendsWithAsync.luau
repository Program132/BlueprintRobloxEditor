local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("IsFriendsWithAsync", {{ name = "UserId", default = "0" }}, {{ name = "IsFriends", default = "false" }}, NodeType.FUNCTION)
