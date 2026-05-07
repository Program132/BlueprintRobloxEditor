local Helper = require(script.Parent.SoundServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetMixerTime", {}, {{ name = "Time", default = "0" }}, NodeType.FUNCTION)
