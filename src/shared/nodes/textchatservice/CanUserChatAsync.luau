local Helper = require(script.Parent.TextChatServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("CanUserChatAsync", {{ name = "UserId", default = "0" }}, {{ name = "CanChat", default = "false" }}, NodeType.FUNCTION)
