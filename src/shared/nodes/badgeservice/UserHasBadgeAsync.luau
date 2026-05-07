local Helper = require(script.Parent.BadgeServiceMethod)
return Helper.create("UserHasBadgeAsync", {
	{ name = "UserId", default = "0" },
	{ name = "BadgeId", default = "0" }
}, {{ name = "HasBadge", default = "false" }}, require(script.Parent.Parent.Parent.NodeType).FUNCTION)
