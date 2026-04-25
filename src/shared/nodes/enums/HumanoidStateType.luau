local EnumFunc = require(script.Parent.EnumFunc)

local values = {
	"FallingDown", "Ragdoll", "GettingUp", "Jumping", "Swimming", "Freefall",
	"Flying", "Landed", "Running", "RunningNoPhysics", "Climbing", "Seated",
	"PlatformStanding", "Dead", "Physics", "None"
}

return EnumFunc.create("HumanoidStateType", "HumanoidStateType", values, "Running")
