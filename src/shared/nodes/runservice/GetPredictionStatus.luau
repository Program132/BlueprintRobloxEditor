local Helper = require(script.Parent.RunServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetPredictionStatus", {
	{ name = "Context", default = "game.Workspace" }
}, {{ name = "Status", default = "Enum.PredictionStatus.None" }}, NodeType.FUNCTION)
