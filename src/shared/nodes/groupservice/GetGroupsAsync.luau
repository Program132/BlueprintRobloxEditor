local Helper = require(script.Parent.GroupServiceMethod)
return Helper.create("GetGroupsAsync", {
	{ name = "UserId", default = "0" }
}, {{ name = "Groups", default = "{}" }}, require(script.Parent.Parent.Parent.NodeType).FUNCTION)
