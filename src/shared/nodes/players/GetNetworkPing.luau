local Helper = require(script.Parent.PlayerMethod)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return Helper.create("GetNetworkPing", {}, {{ name = "Ping", default = "0" }}, NodeType.FUNCTION)
