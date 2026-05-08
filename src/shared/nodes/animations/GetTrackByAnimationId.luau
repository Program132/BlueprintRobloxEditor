local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetTrackByAnimationId", {{ name = "animationId", default = "''" }}, {{ name = "Track", default = "nil" }}, NodeType.FUNCTION)
