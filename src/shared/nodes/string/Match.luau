local StringFunc = require(script.Parent.StringFunc)
return StringFunc.create("String Match", "match", 
	{ {name="String", default='""'}, {name="Pattern", default='""'}, {name="Init", default="1"} },
	{ {name="Result", default='""'} }
)
