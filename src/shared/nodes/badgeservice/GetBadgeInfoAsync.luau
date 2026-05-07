local Helper = require(script.Parent.BadgeServiceMethod)
return Helper.create("GetBadgeInfoAsync", {
	{ name = "BadgeId", default = "0" }
}, {{ name = "Info", default = "{}" }}, require(script.Parent.Parent.Parent.NodeType).FUNCTION)
