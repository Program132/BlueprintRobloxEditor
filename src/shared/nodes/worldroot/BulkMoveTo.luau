local Helper = require(script.Parent.Parent.MethodHelper)
return Helper.create("BulkMoveTo", {
	{ name = "PartList", default = "{}" },
	{ name = "CFrameList", default = "{}" },
	{ name = "EventMode", default = "Enum.BulkMoveMode.FireAllEvents" }
})
