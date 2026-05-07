local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetRankInGroupAsync", {{ name = "GroupId", default = "0" }}, {{ name = "Rank", default = "0" }}, NodeType.FUNCTION)
