local Helper = require(script.Parent.CollectionServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetAllTags", {}, {{ name = "Tags", default = "{}" }}, NodeType.FUNCTION)
