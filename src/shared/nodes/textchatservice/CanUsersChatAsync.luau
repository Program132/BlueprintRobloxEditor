local Helper = require(script.Parent.TextChatServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("CanUsersChatAsync", {
	{ name = "UserIdFrom", default = "0" },
	{ name = "UserIdTo", default = "0" }
}, {{ name = "CanChat", default = "false" }}, NodeType.FUNCTION)
