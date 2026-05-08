local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetScrollVelocity", {}, {{ name = "Velocity", default = "Vector2.new(0, 0)" }}, NodeType.FUNCTION)
