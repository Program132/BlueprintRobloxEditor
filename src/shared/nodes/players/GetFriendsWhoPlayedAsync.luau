local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetFriendsWhoPlayedAsync", {}, {{ name = "Friends", default = "{}" }}, NodeType.FUNCTION)
