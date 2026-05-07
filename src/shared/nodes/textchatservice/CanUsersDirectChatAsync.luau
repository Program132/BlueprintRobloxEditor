local Helper = require(script.Parent.TextChatServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("CanUsersDirectChatAsync", {
	{ name = "RequesterUserId", default = "0" },
	{ name = "UserIds", default = "{}" }
}, {{ name = "Results", default = "{}" }}, NodeType.FUNCTION)
