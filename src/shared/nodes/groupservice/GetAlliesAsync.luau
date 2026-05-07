local Helper = require(script.Parent.GroupServiceMethod)
return Helper.create("GetAlliesAsync", {
	{ name = "GroupId", default = "0" }
}, {{ name = "Allies", default = "nil" }}, require(script.Parent.Parent.Parent.NodeType).FUNCTION)
