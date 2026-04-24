local StringFunc = require(script.Parent.StringFunc)
return StringFunc.create("String Byte", "byte", 
	{ {name="String", default='""'}, {name="Index", default="1"} },
	{ {name="Result", default="0"} }
)
