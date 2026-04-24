local TableFunc = require(script.Parent.TableFunc)
local NodeType = require(script.Parent.Parent.Parent.NodeType)
return TableFunc.create("Table Freeze", "freeze", { {name="Table", default="{}"} }, { {name="Table", default="{}"} }, NodeType.METHOD)
