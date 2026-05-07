local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetJoinData", {}, {{ name = "JoinData", default = "{}" }}, NodeType.FUNCTION)
