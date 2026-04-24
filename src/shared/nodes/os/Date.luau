local OSFunc = require(script.Parent.OSFunc)
return OSFunc.create("OS Date", "date", { {name="Format", default="\"*t\""}, {name="Time", default="nil"} }, { {name="Date", default="{}"} })
