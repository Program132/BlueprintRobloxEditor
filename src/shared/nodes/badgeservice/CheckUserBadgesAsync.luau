local Helper = require(script.Parent.BadgeServiceMethod)
return Helper.create("CheckUserBadgesAsync", {
	{ name = "UserId", default = "0" },
	{ name = "BadgeIds", default = "{}" }
}, {{ name = "Badges", default = "{}" }})
