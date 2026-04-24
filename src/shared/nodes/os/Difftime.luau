local OSFunc = require(script.Parent.OSFunc)
return OSFunc.create("OS Difftime", "difftime", { {name="T2", default="0"}, {name="T1", default="0"} }, { {name="Diff", default="0"} })
