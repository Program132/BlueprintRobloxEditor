local TableFunc = require(script.Parent.TableFunc)
return TableFunc.create("Table Unpack", "unpack", 
	{ {name="Table", default="{}"}, {name="Start", default="1"}, {name="End", default="#t"} }, 
	{ {name="Result", default="nil"} }
)
