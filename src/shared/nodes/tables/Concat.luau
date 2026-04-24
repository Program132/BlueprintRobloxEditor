local TableFunc = require(script.Parent.TableFunc)
return TableFunc.create("Table Concat", "concat", 
	{ {name="Table", default="{}"}, {name="Separator", default='""'}, {name="Start", default="1"}, {name="End", default="#t"} }, 
	{ {name="Result", default='""'} }
)
