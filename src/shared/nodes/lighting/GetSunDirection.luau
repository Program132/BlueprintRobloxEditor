local Helper = require(script.Parent.LightingMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetSunDirection", {}, {{ name = "Direction", default = "Vector3.new()" }}, NodeType.FUNCTION)
