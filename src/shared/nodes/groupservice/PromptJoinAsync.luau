local Helper = require(script.Parent.GroupServiceMethod)
return Helper.create("PromptJoinAsync", {
	{ name = "GroupId", default = "0" }
}, {{ name = "Status", default = "Enum.GroupMembershipStatus.None" }})
