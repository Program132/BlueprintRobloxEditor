local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("DistanceFromCharacter", {{ name = "Point", default = "Vector3.new()" }}, {{ name = "Distance", default = "0" }}, NodeType.FUNCTION)
