local Helper = require(script.Parent.Parent.EventHelper)
return Helper.create("DidLoop", {
	{ name = "soundId", default = "''" },
	{ name = "numOfTimesLooped", default = "0" }
})
