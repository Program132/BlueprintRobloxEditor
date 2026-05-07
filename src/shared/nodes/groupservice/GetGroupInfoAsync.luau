local Helper = require(script.Parent.GroupServiceMethod)
return Helper.create("GetGroupInfoAsync", {
	{ name = "GroupId", default = "0" }
}, {{ name = "Info", default = "{}" }}, require(script.Parent.Parent.Parent.NodeType).FUNCTION)
