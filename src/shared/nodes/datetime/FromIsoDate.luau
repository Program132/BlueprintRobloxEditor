local DateTimeFunc = require(script.Parent.DateTimeFunc)
return DateTimeFunc.create("DateTime FromIsoDate", "fromIsoDate", { {name="IsoDate", default="\"\""} }, { {name="DateTime", default="nil"} }, nil, true)
