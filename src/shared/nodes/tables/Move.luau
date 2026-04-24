local TableFunc = require(script.Parent.TableFunc)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return TableFunc.create("Table Move", "move", 
	{ {name="Src", default="{}"}, {name="Start", default="1"}, {name="End", default="1"}, {name="DestPos", default="1"}, {name="Dest", default="src"} }, 
	{ {name="Result", default="{}"} },
	NodeType.METHOD
)
