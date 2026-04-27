local InstanceAction = require(script.Parent.InstanceAction)
return InstanceAction.create("Set Attribute", "SetAttribute", {{name = "Attribute", default = '""'}, {name = "Value", default = "nil"}})
