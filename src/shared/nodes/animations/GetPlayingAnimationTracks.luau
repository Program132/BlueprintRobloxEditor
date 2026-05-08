local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetPlayingAnimationTracks", {}, {{ name = "Tracks", default = "{}" }}, NodeType.FUNCTION)
