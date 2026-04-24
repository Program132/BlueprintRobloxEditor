local StringFunc = require(script.Parent.StringFunc)
return StringFunc.create("String Rep", "rep", 
	{ {name="String", default='""'}, {name="Count", default="1"} },
	{ {name="Result", default='""'} }
)
