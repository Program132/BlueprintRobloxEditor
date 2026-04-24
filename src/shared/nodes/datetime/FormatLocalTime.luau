local DateTimeFunc = require(script.Parent.DateTimeFunc)
return DateTimeFunc.create("DateTime FormatLocalTime", "FormatLocalTime", { {name="Format", default="\"LL\""}, {name="Locale", default="\"en-us\""} }, { {name="String", default="\"\""} })
