local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("HasAppearanceLoaded", {}, {{ name = "Loaded", default = "false" }}, NodeType.FUNCTION)
