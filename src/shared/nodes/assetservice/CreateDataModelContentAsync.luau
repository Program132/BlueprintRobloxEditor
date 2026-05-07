local Helper = require(script.Parent.AssetServiceMethod)
return Helper.create("CreateDataModelContentAsync", {
	{ name = "Content", default = "''" },
	{ name = "Options", default = "{}" }
}, {
	{ name = "ContentId", default = "''" },
	{ name = "Status", default = "''" }
})
