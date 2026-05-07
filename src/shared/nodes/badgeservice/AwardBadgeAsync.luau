local Helper = require(script.Parent.BadgeServiceMethod)
return Helper.create("AwardBadgeAsync", {
	{ name = "UserId", default = "0" },
	{ name = "BadgeId", default = "0" }
}, {{ name = "Success", default = "false" }})
