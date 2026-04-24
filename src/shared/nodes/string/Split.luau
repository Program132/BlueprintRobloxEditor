local StringFunc = require(script.Parent.StringFunc)
return StringFunc.create("String Split", "split", 
	{ {name="String", default='""'}, {name="Separator", default='","'} },
	{ {name="Result", default="{}"} }
)
