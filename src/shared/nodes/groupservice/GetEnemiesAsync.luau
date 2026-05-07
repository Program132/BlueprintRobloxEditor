local Helper = require(script.Parent.GroupServiceMethod)
return Helper.create("GetEnemiesAsync", {
	{ name = "GroupId", default = "0" }
}, {{ name = "Enemies", default = "nil" }}, require(script.Parent.Parent.Parent.NodeType).FUNCTION)
