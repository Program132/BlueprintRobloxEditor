local TableFunc = require(script.Parent.TableFunc)
return TableFunc.create("Table Find", "find", 
	{ {name="Table", default="{}"}, {name="Value", default="nil"}, {name="Init", default="1"} }, 
	{ {name="Index", default="nil"} }
)
