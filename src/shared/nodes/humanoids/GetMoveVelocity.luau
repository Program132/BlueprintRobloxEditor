local Helper = require(script.Parent.Parent.MethodHelper)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetMoveVelocity", {}, {{ name = "Velocity", default = "Vector3.new(0, 0, 0)" }}, NodeType.FUNCTION)
