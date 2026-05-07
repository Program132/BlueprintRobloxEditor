local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetFriendsOnlineAsync", {{ name = "MaxFriends", default = "200" }}, {{ name = "Friends", default = "{}" }}, NodeType.FUNCTION)
