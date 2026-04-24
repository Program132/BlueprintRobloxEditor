local DateTimeFunc = require(script.Parent.DateTimeFunc)
return DateTimeFunc.create("DateTime UnixTimestamp", "UnixTimestamp", {}, { {name="Timestamp", default="0"} }, nil, false, true)
