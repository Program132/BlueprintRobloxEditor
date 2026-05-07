local Helper = require(script.Parent.SoundServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetListener", {}, {
	{ name = "Type", default = "Enum.ListenerType.Camera" },
	{ name = "Listener", default = "nil" }
}, NodeType.FUNCTION)
