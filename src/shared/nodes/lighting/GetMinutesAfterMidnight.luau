local Helper = require(script.Parent.LightingMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetMinutesAfterMidnight", {}, {{ name = "Minutes", default = "0" }}, NodeType.FUNCTION)
