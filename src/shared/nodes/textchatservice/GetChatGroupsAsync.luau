local Helper = require(script.Parent.TextChatServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetChatGroupsAsync", {
	{ name = "Players", default = "{}" }
}, {{ name = "Groups", default = "{}" }}, NodeType.FUNCTION)
