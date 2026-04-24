local StringFunc = require(script.Parent.StringFunc)
return StringFunc.create("String Sub", "sub", 
	{ {name="String", default='""'}, {name="Start", default="1"}, {name="End", default="-1"} },
	{ {name="Result", default='""'} }
)
