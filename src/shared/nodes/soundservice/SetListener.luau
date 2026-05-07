local Helper = require(script.Parent.SoundServiceMethod)
return Helper.create("SetListener", {
	{ name = "ListenerType", default = "Enum.ListenerType.Camera" },
	{ name = "Listener", default = "nil" }
}, {})
