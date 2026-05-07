local Helper = require(script.Parent.TextChatServiceMethod)
return Helper.create("DisplayBubble", {
	{ name = "PartOrCharacter", default = "nil" },
	{ name = "Message", default = "''" }
}, {})
