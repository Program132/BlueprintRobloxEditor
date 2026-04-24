local TableFunc = require(script.Parent.TableFunc)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return TableFunc.create("Table Clear", "clear", { {name="Table", default="{}"} }, {}, NodeType.METHOD)
