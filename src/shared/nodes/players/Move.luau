local Helper = require(script.Parent.PlayerMethod)
return Helper.create("Move", {
	{ name = "WalkDirection", default = "Vector3.new()" },
	{ name = "RelativeToCamera", default = "false" }
}, {})
