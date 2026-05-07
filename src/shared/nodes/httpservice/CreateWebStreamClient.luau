local Helper = require(script.Parent.HttpServiceMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("CreateWebStreamClient", {
	{ name = "Type", default = "Enum.WebStreamClientType.Default" },
	{ name = "Options", default = "{}" }
}, {{ name = "Client", default = "nil" }}, NodeType.FUNCTION)
