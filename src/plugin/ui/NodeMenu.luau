local NodeMenu = {}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local NODES_DATA = {
	{
		category = "Events",
		color = Color3.fromRGB(150, 40, 40),
		items = {
			{ id = "Start Event", name = "Start Event", type = "Event" }
		}
	},
	{
		category = "Networking",
		color = Color3.fromRGB(255, 120, 0),
		items = {
			{ id = "FireServer", name = "Fire Server", type = "Action" },
			{ id = "FireClient", name = "Fire Client", type = "Action" },
			{ id = "FireAllClients", name = "Fire All Clients", type = "Action" },
			{ id = "OnServerEvent", name = "On Server Event", type = "Event" },
			{ id = "OnClientEvent", name = "On Client Event", type = "Event" },
			{ id = "InvokeServer", name = "Invoke Server", type = "Action" },
			{ id = "InvokeClient", name = "Invoke Client", type = "Action" },
			{ id = "OnServerInvoke", name = "On Server Invoke", type = "Event" },
			{ id = "OnClientInvoke", name = "On Client Invoke", type = "Event" },
			{ id = "Remote Return", name = "Remote Return", type = "Action" },
		}
	},
	{
		category = "MarketplaceService",
		color = Color3.fromRGB(255, 170, 0),
		items = {
			{ id = "MarketplaceService PromptPurchaseFinished", name = "MarketplaceService PromptPurchaseFinished", type = "Event" },
			{ id = "MarketplaceService PromptProductPurchaseFinished", name = "MarketplaceService PromptProductPurchaseFinished", type = "Event" },
			{ id = "MarketplaceService PromptGamePassPurchaseFinished", name = "MarketplaceService PromptGamePassPurchaseFinished", type = "Event" },
			{ id = "MarketplaceService PromptBundlePurchaseFinished", name = "MarketplaceService PromptBundlePurchaseFinished", type = "Event" },
			{ id = "MarketplaceService PromptPremiumPurchaseFinished", name = "MarketplaceService PromptPremiumPurchaseFinished", type = "Event" },
			{ id = "MarketplaceService PromptSubscriptionPurchaseFinished", name = "MarketplaceService PromptSubscriptionPurchaseFinished", type = "Event" },
			{ id = "MarketplaceService PromptRobloxSubscriptionPurchaseFinished", name = "MarketplaceService PromptRobloxSubscriptionPurchaseFinished", type = "Event" },
			{ id = "MarketplaceService GetProductInfoAsync", name = "MarketplaceService GetProductInfoAsync", type = "Function" },
			{ id = "MarketplaceService UserOwnsGamePassAsync", name = "MarketplaceService UserOwnsGamePassAsync", type = "Function" },
			{ id = "MarketplaceService PlayerOwnsAssetAsync", name = "MarketplaceService PlayerOwnsAssetAsync", type = "Function" },
			{ id = "MarketplaceService PlayerOwnsBundleAsync", name = "MarketplaceService PlayerOwnsBundleAsync", type = "Function" },
			{ id = "MarketplaceService PromptPurchase", name = "MarketplaceService PromptPurchase", type = "Method" },
			{ id = "MarketplaceService PromptProductPurchase", name = "MarketplaceService PromptProductPurchase", type = "Method" },
			{ id = "MarketplaceService PromptGamePassPurchase", name = "MarketplaceService PromptGamePassPurchase", type = "Method" },
			{ id = "MarketplaceService PromptBundlePurchase", name = "MarketplaceService PromptBundlePurchase", type = "Method" },
			{ id = "MarketplaceService PromptBulkPurchase", name = "MarketplaceService PromptBulkPurchase", type = "Method" },
			{ id = "MarketplaceService PromptSubscriptionPurchase", name = "MarketplaceService PromptSubscriptionPurchase", type = "Method" },
			{ id = "MarketplaceService PromptRobloxSubscriptionPurchase", name = "MarketplaceService PromptRobloxSubscriptionPurchase", type = "Method" },
			{ id = "MarketplaceService PromptCancelSubscription", name = "MarketplaceService PromptCancelSubscription", type = "Method" },
			{ id = "MarketplaceService GetDeveloperProductsAsync", name = "MarketplaceService GetDeveloperProductsAsync", type = "Function" },
			{ id = "MarketplaceService GetSubscriptionProductInfoAsync", name = "MarketplaceService GetSubscriptionProductInfoAsync", type = "Function" },
			{ id = "MarketplaceService GetRobloxSubscriptionDetailsAsync", name = "MarketplaceService GetRobloxSubscriptionDetailsAsync", type = "Function" },
			{ id = "MarketplaceService GetUsersPriceLevelsAsync", name = "MarketplaceService GetUsersPriceLevelsAsync", type = "Function" },
			{ id = "MarketplaceService GetUserSubscriptionDetailsAsync", name = "MarketplaceService GetUserSubscriptionDetailsAsync", type = "Function" },
			{ id = "MarketplaceService GetUserSubscriptionPaymentHistoryAsync", name = "MarketplaceService GetUserSubscriptionPaymentHistoryAsync", type = "Function" },
			{ id = "MarketplaceService GetUserSubscriptionStatusAsync", name = "MarketplaceService GetUserSubscriptionStatusAsync", type = "Function" },
			{ id = "MarketplaceService RankProductsAsync", name = "MarketplaceService RankProductsAsync", type = "Function" },
			{ id = "MarketplaceService RecommendTopProductsAsync", name = "MarketplaceService RecommendTopProductsAsync", type = "Function" },
		}
	},
	{
		category = "Variables",
		color = Color3.fromRGB(80, 80, 80),
		items = {
			{ id = "Get Variable", name = "Get Variable", type = "Variable" },
			{ id = "Set Variable", name = "Set Variable", type = "Variable" },
		}
	},
	{
		category = "Globals",
		color = Color3.fromRGB(200, 200, 200),
		items = {
			{ id = "game", name = "game", type = "Constant" },
			{ id = "workspace", name = "workspace", type = "Constant" },
			{ id = "script", name = "script", type = "Constant" },
		}
	},
	{
		category = "Conversions",
		color = Color3.fromRGB(120, 100, 180),
		items = {
			{ id = "Instance To BasePart", name = "Instance To BasePart", type = "Function" },
			{ id = "Instance To Part", name = "Instance To Part", type = "Function" },
			{ id = "Instance To Model", name = "Instance To Model", type = "Function" },
			{ id = "Instance To Folder", name = "Instance To Folder", type = "Function" },
			{ id = "Instance To MeshPart", name = "Instance To MeshPart", type = "Function" },
			{ id = "Instance To Humanoid", name = "Instance To Humanoid", type = "Function" },
			{ id = "Instance To Player", name = "Instance To Player", type = "Function" },
			{ id = "Instance To Sound", name = "Instance To Sound", type = "Function" },
			{ id = "Instance To Tool", name = "Instance To Tool", type = "Function" },
			{ id = "Instance To StarterGui", name = "Instance To StarterGui", type = "Function" },
			{ id = "Instance To Camera", name = "Instance To Camera", type = "Function" },
			{ id = "ToString", name = "To String", type = "Function" },
			{ id = "ToNumber", name = "To Number", type = "Function" },
		}
	},
	{
		category = "Methods",
		color = Color3.fromRGB(40, 100, 150),
		items = {
			{ id = "Print", name = "Print", type = "Method" },
			{ id = "Warn", name = "Warn", type = "Method" },
			{ id = "Error", name = "Error", type = "Method" }
		}
	},
	{
		category = "Math",
		color = Color3.fromRGB(40, 150, 70),
		items = {
			{ id = "Add", name = "Add", type = "Function" },
			{ id = "Subtract", name = "Subtract", type = "Function" },
			{ id = "Multiply", name = "Multiply", type = "Function" },
			{ id = "Divide", name = "Divide", type = "Function" },
			{ id = "Abs", name = "Absolute Value (Abs)", type = "Function" },
			{ id = "Sqrt", name = "Square Root (Sqrt)", type = "Function" },
			{ id = "Floor", name = "Floor", type = "Function" },
			{ id = "Ceil", name = "Ceil", type = "Function" },
			{ id = "Fmod", name = "Remainder (Fmod)", type = "Function" },
			{ id = "Pow", name = "Power (Pow)", type = "Function" },
			{ id = "Min", name = "Minimum (Min)", type = "Function" },
			{ id = "Max", name = "Maximum (Max)", type = "Function" },
			{ id = "Exp", name = "Exponential (Exp)", type = "Function" },
			{ id = "Log", name = "Natural Log (Log)", type = "Function" },
			{ id = "Log10", name = "Base-10 Log (Log10)", type = "Function" },
			{ id = "Ldexp", name = "Ldexp", type = "Function" },
			{ id = "Random", name = "Random Number", type = "Function" },
			{ id = "Random Seed", name = "Set Random Seed", type = "Method" },
			{ id = "Pi", name = "Constant: Pi", type = "Function" },
			{ id = "Huge", name = "Constant: Huge", type = "Function" },
			{ id = "Sin", name = "Trig: Sine (Sin)", type = "Function" },
			{ id = "Cos", name = "Trig: Cosine (Cos)", type = "Function" },
			{ id = "Tan", name = "Trig: Tangent (Tan)", type = "Function" },
			{ id = "Asin", name = "Trig: Arc Sine (Asin)", type = "Function" },
			{ id = "Acos", name = "Trig: Arc Cosine (Acos)", type = "Function" },
			{ id = "Atan", name = "Trig: Arc Tangent (Atan)", type = "Function" },
			{ id = "Atan2", name = "Trig: Atan2", type = "Function" },
			{ id = "Sinh", name = "Trig: Hyperbolic Sine (Sinh)", type = "Function" },
			{ id = "Cosh", name = "Trig: Hyperbolic Cosine (Cosh)", type = "Function" },
			{ id = "Tanh", name = "Trig: Hyperbolic Tangent (Tanh)", type = "Function" },
			{ id = "Deg", name = "Trig: Rad to Deg", type = "Function" },
			{ id = "Rad", name = "Trig: Deg to Rad", type = "Function" },
		}
	},
	{
		category = "String",
		color = Color3.fromRGB(180, 70, 70),
		items = {
			{ id = "String Lower", name = "To Lowercase", type = "Function" },
			{ id = "String Upper", name = "To Uppercase", type = "Function" },
			{ id = "String Len", name = "Length (Len)", type = "Function" },
			{ id = "String Reverse", name = "Reverse", type = "Function" },
			{ id = "String Sub", name = "Substring (Sub)", type = "Function" },
			{ id = "String Rep", name = "Repeat (Rep)", type = "Function" },
			{ id = "String Split", name = "Split", type = "Function" },
			{ id = "String Find", name = "Find Pattern", type = "Function" },
			{ id = "String GSub", name = "Global Replace (GSub)", type = "Function" },
			{ id = "String Match", name = "Match Pattern", type = "Function" },
			{ id = "String Byte", name = "Char to Byte", type = "Function" },
			{ id = "String Char", name = "Byte to Char", type = "Function" },
			{ id = "String Format", name = "Format String", type = "Function" },
			{ id = "Concat", name = "Concat (..)", type = "Function" },
		}
	},
	{
		category = "Instances",
		color = Color3.fromRGB(100, 180, 255),
		items = {
			{ id = "Instance Workspace Object", name = "Workspace Object", type = "Function" },
			{ id = "Get Service", name = "Get Service", type = "Function" },
			{ id = "Instance Child", name = "Instance Child", type = "Function" },
			{ id = "Instance Get Parent", name = "Get Parent", type = "Function" },
			{ id = "Instance Clone", name = "Clone", type = "Function" },
			{ id = "Instance Destroy", name = "Destroy", type = "Action" },
			{ id = "Instance Clear All Children", name = "Clear All Children", type = "Action" },
			{ id = "Instance Get Children", name = "Get Children", type = "Function" },
			{ id = "Instance Get Descendants", name = "Get Descendants", type = "Function" },
			{ id = "Instance Get Full Name", name = "Get Full Name", type = "Function" },
			{ id = "Instance Is A", name = "Is A", type = "Function" },
			{ id = "Instance Has Tag", name = "Has Tag", type = "Function" },
			{ id = "Instance Add Tag", name = "Add Tag", type = "Action" },
			{ id = "Instance Remove Tag", name = "Remove Tag", type = "Action" },
			{ id = "Instance Get Attribute", name = "Get Attribute", type = "Function" },
			{ id = "Instance Set Attribute", name = "Set Attribute", type = "Action" },
			{ id = "Instance Is Ancestor Of", name = "Is Ancestor Of", type = "Function" },
			{ id = "Instance Is Descendant Of", name = "Is Descendant Of", type = "Function" },
			{ id = "Instance Find First Child", name = "Find First Child", type = "Function" },
			{ id = "Instance Find First Child Of Class", name = "Find First Child Of Class", type = "Function" },
			{ id = "Instance Find First Child Which Is A", name = "Find First Child Which Is A", type = "Function" },
			{ id = "Instance Wait For Child", name = "Wait For Child", type = "Function" },
			{ id = "Instance Find First Ancestor", name = "Find First Ancestor", type = "Function" },
			{ id = "Instance Find First Ancestor Of Class", name = "Find First Ancestor Of Class", type = "Function" },
			{ id = "Instance Find First Ancestor Which Is A", name = "Find First Ancestor Which Is A", type = "Function" },
			{ id = "Instance Get Property", name = "Get Property", type = "Function" },
			{ id = "Instance Set Property", name = "Set Property", type = "Method" },
		}
	},
	{
		category = "Boolean",
		color = Color3.fromRGB(150, 40, 150),
		items = {
			{ id = "Boolean And", name = "AND", type = "Function" },
			{ id = "Boolean Or", name = "OR", type = "Function" },
			{ id = "Boolean Not", name = "NOT", type = "Function" },
			{ id = "Boolean Equal", name = "Equal (==)", type = "Function" },
			{ id = "Boolean NotEqual", name = "Not Equal (~=)", type = "Function" },
			{ id = "Boolean GreaterThan", name = "Greater Than (>)", type = "Function" },
			{ id = "Boolean GreaterOrEqual", name = "Greater or Equal (>=)", type = "Function" },
			{ id = "Boolean LessThan", name = "Less Than (<)", type = "Function" },
			{ id = "Boolean LessOrEqual", name = "Less or Equal (<=)", type = "Function" },
		}
	},
	{
		category = "Table",
		color = Color3.fromRGB(25, 160, 135),
		items = {
			{ id = "Table Insert", name = "Table Insert", type = "Method" },
			{ id = "Table Remove", name = "Table Remove", type = "Method" },
			{ id = "Table Clear", name = "Table Clear", type = "Method" },
			{ id = "Table Clone", name = "Table Clone", type = "Function" },
			{ id = "Table Concat", name = "Table Concat (to String)", type = "Function" },
			{ id = "Table Find", name = "Table Find", type = "Function" },
			{ id = "Table Freeze", name = "Table Freeze", type = "Method" },
			{ id = "Table Is Frozen", name = "Table Is Frozen?", type = "Function" },
			{ id = "Table Sort", name = "Table Sort", type = "Method" },
			{ id = "Table Unpack", name = "Table Unpack", type = "Function" },
			{ id = "Table Move", name = "Table Move", type = "Method" },
		}
	},
	{
		category = "Vectors",
		color = Color3.fromRGB(240, 200, 50),
		items = {
			{ id = "Vector2 new", name = "Vector2 new", type = "Function" },
			{ id = "Vector2 Lerp", name = "Vector2 Lerp", type = "Method" },
			{ id = "Vector2 Dot", name = "Vector2 Dot", type = "Method" },
			{ id = "Vector2 Cross", name = "Vector2 Cross", type = "Method" },
			{ id = "Vector2 Abs", name = "Vector2 Abs", type = "Method" },
			{ id = "Vector2 Ceil", name = "Vector2 Ceil", type = "Method" },
			{ id = "Vector2 Floor", name = "Vector2 Floor", type = "Method" },
			{ id = "Vector2 Sign", name = "Vector2 Sign", type = "Method" },
			{ id = "Vector2 Angle", name = "Vector2 Angle", type = "Method" },
			{ id = "Vector2 Max", name = "Vector2 Max", type = "Method" },
			{ id = "Vector2 Min", name = "Vector2 Min", type = "Method" },
			{ id = "Vector2 FuzzyEq", name = "Vector2 FuzzyEq", type = "Method" },
			{ id = "Vector3 new", name = "Vector3 new", type = "Function" },
			{ id = "Vector3 zero", name = "Vector3 zero", type = "Constant" },
			{ id = "Vector3 one", name = "Vector3 one", type = "Constant" },
			{ id = "Vector3 xAxis", name = "Vector3 xAxis", type = "Constant" },
			{ id = "Vector3 yAxis", name = "Vector3 yAxis", type = "Constant" },
			{ id = "Vector3 zAxis", name = "Vector3 zAxis", type = "Constant" },
			{ id = "Vector3 Abs", name = "Vector3 Abs", type = "Method" },
			{ id = "Vector3 Ceil", name = "Vector3 Ceil", type = "Method" },
			{ id = "Vector3 Floor", name = "Vector3 Floor", type = "Method" },
			{ id = "Vector3 Sign", name = "Vector3 Sign", type = "Method" },
			{ id = "Vector3 Dot", name = "Vector3 Dot", type = "Method" },
			{ id = "Vector3 Cross", name = "Vector3 Cross", type = "Method" },
			{ id = "Vector3 Lerp", name = "Vector3 Lerp", type = "Method" },
			{ id = "Vector3 Angle", name = "Vector3 Angle", type = "Method" },
			{ id = "Vector3 Max", name = "Vector3 Max", type = "Method" },
			{ id = "Vector3 Min", name = "Vector3 Min", type = "Method" },
			{ id = "Vector3 FuzzyEq", name = "Vector3 FuzzyEq", type = "Method" },
		}
	},
	{
		category = "Ray",
		color = Color3.fromRGB(120, 80, 220),
		items = {
			{ id = "Ray new", name = "Ray new", type = "Function" },
			{ id = "Ray ClosestPoint", name = "Ray ClosestPoint", type = "Method" },
			{ id = "Ray Distance", name = "Ray Distance", type = "Method" },
			{ id = "Ray Unit", name = "Ray Unit", type = "Property" },
			{ id = "Ray Origin", name = "Ray Origin", type = "Property" },
			{ id = "Ray Direction", name = "Ray Direction", type = "Property" },
		}
	},
	{
		category = "CFrame",
		color = Color3.fromRGB(150, 50, 200),
		items = {
			{ id = "CFrame new", name = "CFrame new", type = "Function" },
			{ id = "CFrame new XYZ", name = "CFrame new XYZ", type = "Function" },
			{ id = "CFrame lookAt", name = "CFrame lookAt", type = "Function" },
			{ id = "CFrame Angles", name = "CFrame Angles", type = "Function" },
			{ id = "CFrame Inverse", name = "CFrame Inverse", type = "Method" },
			{ id = "CFrame Lerp", name = "CFrame Lerp", type = "Method" },
			{ id = "CFrame ToWorldSpace", name = "CFrame ToWorldSpace", type = "Method" },
			{ id = "CFrame ToObjectSpace", name = "CFrame ToObjectSpace", type = "Method" },
			{ id = "CFrame PointToWorldSpace", name = "CFrame PointToWorldSpace", type = "Method" },
			{ id = "CFrame PointToObjectSpace", name = "CFrame PointToObjectSpace", type = "Method" },
		}
	},
	{
		category = "Color",
		color = Color3.fromRGB(0, 170, 170),
		items = {
			{ id = "Color3 fromRGB", name = "Color3 fromRGB", type = "Function" },
			{ id = "Color3 fromHSV", name = "Color3 fromHSV", type = "Function" },
			{ id = "Color3 fromHex", name = "Color3 fromHex", type = "Function" },
			{ id = "Color3 Lerp", name = "Color3 Lerp", type = "Method" },
		}
	},
	{
		category = "UI Types",
		color = Color3.fromRGB(0, 200, 150),
		items = {
			{ id = "UDim new", name = "UDim new", type = "Function" },
			{ id = "UDim2 new", name = "UDim2 new", type = "Function" },
			{ id = "UDim2 fromScale", name = "UDim2 fromScale", type = "Function" },
			{ id = "UDim2 fromOffset", name = "UDim2 fromOffset", type = "Function" },
			{ id = "UDim2 Lerp", name = "UDim2 Lerp", type = "Method" },
		}
	},
	{
		category = "Variables",
		color = Color3.fromRGB(180, 130, 40),
		items = {
			{ id = "Get Variable", name = "GET (Variable)", type = "Variable" },
			{ id = "Set Variable", name = "SET (Variable)", type = "Variable" }
		}
	},
	{
		category = "Control",
		color = Color3.fromRGB(130, 40, 180),
		items = {
			{ id = "If", name = "If / Branch", type = "Control" },
			{ id = "While", name = "While", type = "Control" },
			{ id = "pcall", name = "pcall", type = "Control" },
			{ id = "For", name = "For Loop", type = "Control" }
		}
	},
	{
		category = "Task",
		color = Color3.fromRGB(200, 100, 50),
		items = {
			{ id = "Task Wait", name = "Task Wait", type = "Method" },
			{ id = "Task Spawn", name = "Task Spawn", type = "Control" },
			{ id = "Task Defer", name = "Task Defer", type = "Control" },
			{ id = "Task Delay", name = "Task Delay", type = "Control" },
			{ id = "Task Synchronize", name = "Task Synchronize", type = "Method" },
			{ id = "Task Desynchronize", name = "Task Desynchronize", type = "Method" },
			{ id = "Task Cancel", name = "Task Cancel", type = "Method" },
		}
	},
	{
		category = "Tween",
		color = Color3.fromRGB(255, 100, 150),
		items = {
			{ id = "TweenInfo new", name = "TweenInfo new", type = "Function" },
			{ id = "Tween Create", name = "Tween Create", type = "Function" },
			{ id = "Tween Play", name = "Tween Play", type = "Action" },
			{ id = "Tween Pause", name = "Tween Pause", type = "Action" },
			{ id = "Tween Cancel", name = "Tween Cancel", type = "Action" },
		}
	},
	{
		category = "DateTime",
		color = Color3.fromRGB(75, 0, 130),
		items = {
			{ id = "DateTime Now", name = "DateTime Now", type = "Function" },
			{ id = "DateTime FromUnixTimestamp", name = "FromUnixTimestamp", type = "Function" },
			{ id = "DateTime FromIsoDate", name = "FromIsoDate", type = "Function" },
			{ id = "DateTime ToLocalTime", name = "ToLocalTime", type = "Function" },
			{ id = "DateTime ToIsoDate", name = "ToIsoDate", type = "Function" },
			{ id = "DateTime FormatLocalTime", name = "FormatLocalTime", type = "Function" },
			{ id = "DateTime UnixTimestamp", name = "UnixTimestamp", type = "Function" },
		}
	},
	{
		category = "OS",
		color = Color3.fromRGB(70, 90, 110),
		items = {
			{ id = "OS Clock", name = "OS Clock", type = "Function" },
			{ id = "OS Time", name = "OS Time", type = "Function" },
			{ id = "OS Difftime", name = "OS Difftime", type = "Function" },
			{ id = "OS Date", name = "OS Date", type = "Function" },
		}
	},
	{
		category = "Enums",
		color = Color3.fromRGB(150, 150, 40),
		items = {
			{ id = "Enum KeyCode", name = "KeyCode", type = "Enum" },
			{ id = "Enum UserInputType", name = "UserInputType", type = "Enum" },
			{ id = "Enum UserInputState", name = "UserInputState", type = "Enum" },
			{ id = "Enum Material", name = "Material", type = "Enum" },
			{ id = "Enum PartType", name = "PartType", type = "Enum" },
			{ id = "Enum HumanoidStateType", name = "HumanoidStateType", type = "Enum" },
			{ id = "Enum EasingDirection", name = "EasingDirection", type = "Enum" },
			{ id = "Enum EasingStyle", name = "EasingStyle", type = "Enum" },
			{ id = "Enum CameraType", name = "CameraType", type = "Enum" },
			{ id = "Enum CameraMode", name = "CameraMode", type = "Enum" },
			{ id = "Enum ChatRestrictionStatus", name = "ChatRestrictionStatus", type = "Enum" },
			{ id = "Enum DevCameraOcclusionMode", name = "DevCameraOcclusionMode", type = "Enum" },
			{ id = "Enum DevComputerCameraMovementMode", name = "DevComputerCameraMovementMode", type = "Enum" },
			{ id = "Enum DevComputerMovementMode", name = "DevComputerMovementMode", type = "Enum" },
			{ id = "Enum DevTouchCameraMovementMode", name = "DevTouchCameraMovementMode", type = "Enum" },
			{ id = "Enum DevTouchMovementMode", name = "DevTouchMovementMode", type = "Enum" },
			{ id = "Enum PredictionMode", name = "PredictionMode", type = "Enum" },
			{ id = "Enum InfoType", name = "InfoType", type = "Enum" },
			{ id = "Enum CurrencyType", name = "CurrencyType", type = "Enum" },
			{ id = "Enum CoreGuiType", name = "CoreGuiType", type = "Enum" },
			{ id = "Enum RtlTextSupport", name = "RtlTextSupport", type = "Enum" },
			{ id = "Enum ScreenOrientation", name = "ScreenOrientation", type = "Enum" },
			{ id = "Enum GroupMembershipStatus", name = "GroupMembershipStatus", type = "Enum" },
			{ id = "Enum VirtualCursorMode", name = "VirtualCursorMode", type = "Enum" },
			{ id = "Enum ProximityPromptInputType", name = "ProximityPromptInputType", type = "Enum" },
			{ id = "Enum StepFrequency", name = "StepFrequency", type = "Enum" },
			{ id = "Enum ReverbType", name = "ReverbType", type = "Enum" },
			{ id = "Enum ListenerLocation", name = "ListenerLocation", type = "Enum" },
			{ id = "Enum VolumetricAudio", name = "VolumetricAudio", type = "Enum" },
			{ id = "Enum ListenerType", name = "ListenerType", type = "Enum" },
			{ id = "Enum WebStreamClientType", name = "WebStreamClientType", type = "Enum" },
			{ id = "Enum HttpContentType", name = "HttpContentType", type = "Enum" },
			{ id = "Enum LightingStyle", name = "LightingStyle", type = "Enum" },
			{ id = "Enum RolloutState", name = "RolloutState", type = "Enum" },
			{ id = "Enum StepFrequency", name = "StepFrequency", type = "Enum" },
			{ id = "Enum StepFrequency", name = "StepFrequency", type = "Enum" },
			{ id = "Enum RunState", name = "RunState", type = "Enum" },
			{ id = "Enum TeleportResult", name = "TeleportResult", type = "Enum" },
			{ id = "Enum DataStoreRequestType", name = "DataStoreRequestType", type = "Enum" },
			{ id = "Enum SortDirection", name = "SortDirection", type = "Enum" },
			{ id = "Enum TextXAlignment", name = "TextXAlignment", type = "Enum" },
			{ id = "Enum TextYAlignment", name = "TextYAlignment", type = "Enum" },
			{ id = "Enum TextTruncate", name = "TextTruncate", type = "Enum" },
			{ id = "Enum TextDirection", name = "TextDirection", type = "Enum" },
			{ id = "Enum FontSize", name = "FontSize", type = "Enum" },
			{ id = "Enum Font", name = "Font", type = "Enum" },
			{ id = "Enum FrameStyle", name = "FrameStyle", type = "Enum" },
			{ id = "Enum AutomaticSize", name = "AutomaticSize", type = "Enum" },
			{ id = "Enum BorderMode", name = "BorderMode", type = "Enum" },
			{ id = "Enum GuiState", name = "GuiState", type = "Enum" },
			{ id = "Enum InputSink", name = "InputSink", type = "Enum" },
			{ id = "Enum SizeConstraint", name = "SizeConstraint", type = "Enum" },
			{ id = "Enum ResamplerMode", name = "ResamplerMode", type = "Enum" },
			{ id = "Enum ScaleType", name = "ScaleType", type = "Enum" },
			{ id = "Enum SelectionBehavior", name = "SelectionBehavior", type = "Enum" },
			{ id = "Enum SafeAreaCompatibility", name = "SafeAreaCompatibility", type = "Enum" },
			{ id = "Enum ScreenInsets", name = "ScreenInsets", type = "Enum" },
			{ id = "Enum ZIndexBehavior", name = "ZIndexBehavior", type = "Enum" },
			{ id = "Enum ElasticBehavior", name = "ElasticBehavior", type = "Enum" },
			{ id = "Enum ScrollBarInset", name = "ScrollBarInset", type = "Enum" },
			{ id = "Enum ScrollingDirection", name = "ScrollingDirection", type = "Enum" },
			{ id = "Enum VerticalScrollBarPosition", name = "VerticalScrollBarPosition", type = "Enum" },
		}
	},
	{
		category = "DataStoreService",
		color = Color3.fromRGB(180, 40, 40),
		items = {
			{ id = "DataStoreService GetDataStore", name = "DataStoreService GetDataStore", type = "Function" },
			{ id = "DataStoreService GetGlobalDataStore", name = "DataStoreService GetGlobalDataStore", type = "Function" },
			{ id = "DataStoreService GetOrderedDataStore", name = "DataStoreService GetOrderedDataStore", type = "Function" },
			{ id = "DataStoreService GetRequestBudgetForRequestType", name = "DataStoreService GetRequestBudgetForRequestType", type = "Function" },
			{ id = "DataStoreService ListDataStoresAsync", name = "DataStoreService ListDataStoresAsync", type = "Method" },
			{ id = "DataStoreService SetRateLimitForRequestType", name = "DataStoreService SetRateLimitForRequestType", type = "Method" },
			{ id = "DataStore GetVersionAsync", name = "DataStore GetVersionAsync", type = "Function" },
			{ id = "DataStore GetVersionAtTimeAsync", name = "DataStore GetVersionAtTimeAsync", type = "Function" },
			{ id = "DataStore ListKeysAsync", name = "DataStore ListKeysAsync", type = "Method" },
			{ id = "DataStore ListVersionsAsync", name = "DataStore ListVersionsAsync", type = "Method" },
			{ id = "DataStore GetAsync", name = "DataStore GetAsync", type = "Function" },
			{ id = "DataStore IncrementAsync", name = "DataStore IncrementAsync", type = "Method" },
			{ id = "DataStore RemoveAsync", name = "DataStore RemoveAsync", type = "Method" },
			{ id = "DataStore SetAsync", name = "DataStore SetAsync", type = "Method" },
			{ id = "DataStore UpdateAsync", name = "DataStore UpdateAsync", type = "Method" },
		}
	},
	{
		category = "TeleportService",
		color = Color3.fromRGB(0, 150, 150),
		items = {
			{ id = "TeleportService GetArrivingTeleportGui", name = "TeleportService GetArrivingTeleportGui", type = "Function" },
			{ id = "TeleportService GetLocalPlayerTeleportData", name = "TeleportService GetLocalPlayerTeleportData", type = "Function" },
			{ id = "TeleportService GetTeleportSetting", name = "TeleportService GetTeleportSetting", type = "Function" },
			{ id = "TeleportService GetPlayerPlaceInstanceAsync", name = "TeleportService GetPlayerPlaceInstanceAsync", type = "Function" },
			{ id = "TeleportService PromptExperienceDetailsAsync", name = "TeleportService PromptExperienceDetailsAsync", type = "Method" },
			{ id = "TeleportService ReserveServer", name = "TeleportService ReserveServer", type = "Method" },
			{ id = "TeleportService SetTeleportGui", name = "TeleportService SetTeleportGui", type = "Method" },
			{ id = "TeleportService SetTeleportSetting", name = "TeleportService SetTeleportSetting", type = "Method" },
			{ id = "TeleportService TeleportAsync", name = "TeleportService TeleportAsync", type = "Method" },
			{ id = "Event TeleportService LocalPlayerArrivedFromTeleport", name = "Event TeleportService LocalPlayerArrivedFromTeleport", type = "Event" },
			{ id = "Event TeleportService TeleportInitFailed", name = "Event TeleportService TeleportInitFailed", type = "Event" },
		}
	},
	{
		category = "Modules",
		color = Color3.fromRGB(150, 100, 40),
		items = {
			{ id = "Require", name = "Require", type = "Function" },
			{ id = "Module Call", name = "Module Call", type = "Method" }
		}
	},
	{
		category = "Players",
		color = Color3.fromRGB(0, 160, 255),
		items = {
			{ id = "Get Local Player", name = "Get LocalPlayer", type = "Function" },
			{ id = "Get Player From Character", name = "Get Player From Character", type = "Function" },
			{ id = "Event Player Added", name = "PlayerAdded", type = "Event" },
			{ id = "Player PlayerRemoving", name = "PlayerRemoving", type = "Event" },
			{ id = "Player AddReplicationFocus", name = "Player AddReplicationFocus", type = "Method" },
			{ id = "Player ClearCharacterAppearance", name = "Player ClearCharacterAppearance", type = "Method" },
			{ id = "Player DistanceFromCharacter", name = "Player DistanceFromCharacter", type = "Function" },
			{ id = "Player GetFriendsOnlineAsync", name = "Player GetFriendsOnlineAsync", type = "Function" },
			{ id = "Player GetFriendsWhoPlayedAsync", name = "Player GetFriendsWhoPlayedAsync", type = "Function" },
			{ id = "Player GetJoinData", name = "Player GetJoinData", type = "Function" },
			{ id = "Player GetMouse", name = "Player GetMouse", type = "Function" },
			{ id = "Player GetNetworkPing", name = "Player GetNetworkPing", type = "Function" },
			{ id = "Player GetRankInGroupAsync", name = "Player GetRankInGroupAsync", type = "Function" },
			{ id = "Player GetRoleInGroupAsync", name = "Player GetRoleInGroupAsync", type = "Function" },
			{ id = "Player HasAppearanceLoaded", name = "Player HasAppearanceLoaded", type = "Function" },
			{ id = "Player IsFriendsWithAsync", name = "Player IsFriendsWithAsync", type = "Function" },
			{ id = "Player IsInGroupAsync", name = "Player IsInGroupAsync", type = "Function" },
			{ id = "Player IsVerified", name = "Player IsVerified", type = "Function" },
			{ id = "Player Kick", name = "Player Kick", type = "Method" },
			{ id = "Player LoadCharacterAsync", name = "Player LoadCharacterAsync", type = "Method" },
			{ id = "Player LoadCharacterWithHumanoidDescriptionAsync", name = "Player LoadCharacterWithHumanoidDescriptionAsync", type = "Method" },
			{ id = "Player Move", name = "Player Move", type = "Method" },
			{ id = "Player RemoveReplicationFocus", name = "Player RemoveReplicationFocus", type = "Method" },
			{ id = "Player RequestStreamAroundAsync", name = "Player RequestStreamAroundAsync", type = "Method" },
			{ id = "Player SetAccountAge", name = "Player SetAccountAge", type = "Method" },
			{ id = "Player SetSuperSafeChat", name = "Player SetSuperSafeChat", type = "Method" },
			{ id = "Event CharacterAdded", name = "CharacterAdded", type = "Event" },
			{ id = "Event CharacterAppearanceLoaded", name = "CharacterAppearanceLoaded", type = "Event" },
			{ id = "Event CharacterRemoving", name = "CharacterRemoving", type = "Event" },
			{ id = "Event Chatted", name = "Chatted", type = "Event" },
			{ id = "Event Idled", name = "Idled", type = "Event" },
			{ id = "Event OnTeleport", name = "OnTeleport", type = "Event" },
			{ id = "Get Name From UserIdAsync", name = "GetNameFromUserIdAsync", type = "Function" },
			{ id = "Get UserId FromNameAsync", name = "GetUserIdFromNameAsync", type = "Function" },
		}
	},
	{
		category = "Tools",
		color = Color3.fromRGB(0, 180, 100),
		items = {
			{ id = "Event Tool Activated", name = "Activated", type = "Event" },
			{ id = "Event Tool Deactivated", name = "Deactivated", type = "Event" },
			{ id = "Event Tool Equipped", name = "Equipped", type = "Event" },
			{ id = "Event Tool Unequipped", name = "Unequipped", type = "Event" },
			{ id = "Activate Tool", name = "Activate", type = "Method" },
			{ id = "Deactivate Tool", name = "Deactivate", type = "Method" },
		}
	},
	{
		category = "StarterGui",
		color = Color3.fromRGB(255, 50, 150),
		items = {
			{ id = "StarterGui GetCore", name = "StarterGui GetCore", type = "Function" },
			{ id = "StarterGui GetCoreGuiEnabled", name = "StarterGui GetCoreGuiEnabled", type = "Function" },
			{ id = "StarterGui SetCore", name = "StarterGui SetCore", type = "Method" },
			{ id = "StarterGui SetCoreGuiEnabled", name = "StarterGui SetCoreGuiEnabled", type = "Method" },
		}
	},
	{
		category = "UserInputService",
		color = Color3.fromRGB(0, 180, 200),
		items = {
			{ id = "UserInputService CreateVirtualInput", name = "UserInputService CreateVirtualInput", type = "Function" },
			{ id = "UserInputService GamepadSupports", name = "UserInputService GamepadSupports", type = "Function" },
			{ id = "UserInputService GetConnectedGamepads", name = "UserInputService GetConnectedGamepads", type = "Function" },
			{ id = "UserInputService GetDeviceAcceleration", name = "UserInputService GetDeviceAcceleration", type = "Function" },
			{ id = "UserInputService GetDeviceGravity", name = "UserInputService GetDeviceGravity", type = "Function" },
			{ id = "UserInputService GetDeviceRotation", name = "UserInputService GetDeviceRotation", type = "Function" },
			{ id = "UserInputService GetFocusedTextBox", name = "UserInputService GetFocusedTextBox", type = "Function" },
			{ id = "UserInputService GetGamepadConnected", name = "UserInputService GetGamepadConnected", type = "Function" },
			{ id = "UserInputService GetGamepadState", name = "UserInputService GetGamepadState", type = "Function" },
			{ id = "UserInputService GetImageForKeyCode", name = "UserInputService GetImageForKeyCode", type = "Function" },
			{ id = "UserInputService GetKeysPressed", name = "UserInputService GetKeysPressed", type = "Function" },
			{ id = "UserInputService GetLastInputType", name = "UserInputService GetLastInputType", type = "Function" },
			{ id = "UserInputService GetMouseButtonsPressed", name = "UserInputService GetMouseButtonsPressed", type = "Function" },
			{ id = "UserInputService GetMouseDelta", name = "UserInputService GetMouseDelta", type = "Function" },
			{ id = "UserInputService GetMouseLocation", name = "UserInputService GetMouseLocation", type = "Function" },
			{ id = "UserInputService GetNavigationGamepads", name = "UserInputService GetNavigationGamepads", type = "Function" },
			{ id = "UserInputService GetStringForKeyCode", name = "UserInputService GetStringForKeyCode", type = "Function" },
			{ id = "UserInputService GetSupportedGamepadKeyCodes", name = "UserInputService GetSupportedGamepadKeyCodes", type = "Function" },
			{ id = "UserInputService GetUserCFrame", name = "UserInputService GetUserCFrame", type = "Function" },
			{ id = "UserInputService IsGamepadButtonDown", name = "UserInputService IsGamepadButtonDown", type = "Function" },
			{ id = "UserInputService IsKeyDown", name = "UserInputService IsKeyDown", type = "Function" },
			{ id = "UserInputService IsMouseButtonPressed", name = "UserInputService IsMouseButtonPressed", type = "Function" },
			{ id = "UserInputService IsNavigationGamepad", name = "UserInputService IsNavigationGamepad", type = "Function" },
			{ id = "UserInputService RecenterUserHeadCFrame", name = "UserInputService RecenterUserHeadCFrame", type = "Action" },
			{ id = "UserInputService SetNavigationGamepad", name = "UserInputService SetNavigationGamepad", type = "Action" },
			{ id = "Instance to UserInputService", name = "Instance to UserInputService", type = "Function" },
			{ id = "UserInputService DeviceAccelerationChanged", name = "UserInputService DeviceAccelerationChanged", type = "Event" },
			{ id = "UserInputService DeviceGravityChanged", name = "UserInputService DeviceGravityChanged", type = "Event" },
			{ id = "UserInputService DeviceRotationChanged", name = "UserInputService DeviceRotationChanged", type = "Event" },
			{ id = "UserInputService GamepadConnected", name = "UserInputService GamepadConnected", type = "Event" },
			{ id = "UserInputService GamepadDisconnected", name = "UserInputService GamepadDisconnected", type = "Event" },
			{ id = "UserInputService InputBegan", name = "UserInputService InputBegan", type = "Event" },
			{ id = "UserInputService InputChanged", name = "UserInputService InputChanged", type = "Event" },
			{ id = "UserInputService InputEnded", name = "UserInputService InputEnded", type = "Event" },
			{ id = "UserInputService JumpRequest", name = "UserInputService JumpRequest", type = "Event" },
			{ id = "UserInputService LastInputTypeChanged", name = "UserInputService LastInputTypeChanged", type = "Event" },
			{ id = "UserInputService PointerAction", name = "UserInputService PointerAction", type = "Event" },
			{ id = "UserInputService TextBoxFocused", name = "UserInputService TextBoxFocused", type = "Event" },
			{ id = "UserInputService TextBoxFocusReleased", name = "UserInputService TextBoxFocusReleased", type = "Event" },
			{ id = "UserInputService TouchDrag", name = "UserInputService TouchDrag", type = "Event" },
			{ id = "UserInputService TouchEnded", name = "UserInputService TouchEnded", type = "Event" },
			{ id = "UserInputService TouchLongPress", name = "UserInputService TouchLongPress", type = "Event" },
			{ id = "UserInputService TouchMoved", name = "UserInputService TouchMoved", type = "Event" },
			{ id = "UserInputService TouchPan", name = "UserInputService TouchPan", type = "Event" },
			{ id = "UserInputService TouchPinch", name = "UserInputService TouchPinch", type = "Event" },
			{ id = "UserInputService TouchRotate", name = "UserInputService TouchRotate", type = "Event" },
			{ id = "UserInputService TouchStarted", name = "UserInputService TouchStarted", type = "Event" },
			{ id = "UserInputService TouchSwipe", name = "UserInputService TouchSwipe", type = "Event" },
			{ id = "UserInputService TouchTap", name = "UserInputService TouchTap", type = "Event" },
			{ id = "UserInputService TouchTapInWorld", name = "UserInputService TouchTapInWorld", type = "Event" },
			{ id = "UserInputService UserCFrameChanged", name = "UserInputService UserCFrameChanged", type = "Event" },
			{ id = "UserInputService WindowFocused", name = "UserInputService WindowFocused", type = "Event" },
			{ id = "UserInputService WindowFocusReleased", name = "UserInputService WindowFocusReleased", type = "Event" },
		}
	},
	{
		category = "RunService",
		color = Color3.fromRGB(120, 150, 100),
		items = {
			{ id = "RunService BindToRenderStep", name = "RunService BindToRenderStep", type = "Method" },
			{ id = "RunService BindToSimulation", name = "RunService BindToSimulation", type = "Method" },
			{ id = "RunService GetPredictionStatus", name = "RunService GetPredictionStatus", type = "Function" },
			{ id = "RunService IsClient", name = "RunService IsClient", type = "Function" },
			{ id = "RunService IsEdit", name = "RunService IsEdit", type = "Function" },
			{ id = "RunService IsRunMode", name = "RunService IsRunMode", type = "Function" },
			{ id = "RunService IsRunning", name = "RunService IsRunning", type = "Function" },
			{ id = "RunService IsServer", name = "RunService IsServer", type = "Function" },
			{ id = "RunService IsStudio", name = "RunService IsStudio", type = "Function" },
			{ id = "RunService Pause", name = "RunService Pause", type = "Method" },
			{ id = "RunService Reset", name = "RunService Reset", type = "Method" },
			{ id = "RunService Run", name = "RunService Run", type = "Method" },
			{ id = "RunService SetPredictionMode", name = "RunService SetPredictionMode", type = "Method" },
			{ id = "RunService Stop", name = "RunService Stop", type = "Method" },
			{ id = "RunService UnbindFromRenderStep", name = "RunService UnbindFromRenderStep", type = "Method" },
			{ id = "Instance to RunService", name = "Instance to RunService", type = "Function" },
			{ id = "RunService Heartbeat", name = "RunService Heartbeat", type = "Event" },
			{ id = "RunService Misprediction", name = "RunService Misprediction", type = "Event" },
			{ id = "RunService PostSimulation", name = "RunService PostSimulation", type = "Event" },
			{ id = "RunService PreAnimation", name = "RunService PreAnimation", type = "Event" },
			{ id = "RunService PreRender", name = "RunService PreRender", type = "Event" },
			{ id = "RunService PreSimulation", name = "RunService PreSimulation", type = "Event" },
			{ id = "RunService RenderStepped", name = "RunService RenderStepped", type = "Event" },
			{ id = "RunService Rollback", name = "RunService Rollback", type = "Event" },
			{ id = "RunService Stepped", name = "RunService Stepped", type = "Event" },
		}
	},
	{
		category = "HttpService",
		color = Color3.fromRGB(50, 150, 200),
		items = {
			{ id = "HttpService JSONEncode", name = "HttpService JSONEncode", type = "Function" },
			{ id = "HttpService JSONDecode", name = "HttpService JSONDecode", type = "Function" },
			{ id = "HttpService GenerateGUID", name = "HttpService GenerateGUID", type = "Function" },
			{ id = "HttpService UrlEncode", name = "HttpService UrlEncode", type = "Function" },
			{ id = "HttpService GetAsync", name = "HttpService GetAsync", type = "Method" },
			{ id = "HttpService PostAsync", name = "HttpService PostAsync", type = "Method" },
			{ id = "HttpService RequestAsync", name = "HttpService RequestAsync", type = "Method" },
			{ id = "HttpService GetSecret", name = "HttpService GetSecret", type = "Function" },
			{ id = "HttpService CreateWebStreamClient", name = "HttpService CreateWebStreamClient", type = "Function" },
			{ id = "Instance to HttpService", name = "Instance to HttpService", type = "Function" },
		}
	},
	{
		category = "Lighting",
		color = Color3.fromRGB(255, 200, 50),
		items = {
			{ id = "Lighting GetMinutesAfterMidnight", name = "Lighting GetMinutesAfterMidnight", type = "Function" },
			{ id = "Lighting GetSunDirection", name = "Lighting GetSunDirection", type = "Function" },
			{ id = "Lighting GetMoonDirection", name = "Lighting GetMoonDirection", type = "Function" },
			{ id = "Lighting SetMinutesAfterMidnight", name = "Lighting SetMinutesAfterMidnight", type = "Method" },
			{ id = "Lighting LightingChanged", name = "Lighting LightingChanged", type = "Event" },
			{ id = "Instance to Lighting", name = "Instance to Lighting", type = "Function" },
		}
	},
	{
		category = "Debris",
		color = Color3.fromRGB(200, 50, 50),
		items = {
			{ id = "Debris AddItem", name = "Debris AddItem", type = "Method" },
		}
	},
	{
		category = "CollectionService",
		color = Color3.fromRGB(240, 150, 20),
		items = {
			{ id = "CollectionService AddTag", name = "CollectionService AddTag", type = "Method" },
			{ id = "CollectionService RemoveTag", name = "CollectionService RemoveTag", type = "Method" },
			{ id = "CollectionService HasTag", name = "CollectionService HasTag", type = "Function" },
			{ id = "CollectionService GetTags", name = "CollectionService GetTags", type = "Function" },
			{ id = "CollectionService GetTagged", name = "CollectionService GetTagged", type = "Function" },
			{ id = "CollectionService GetAllTags", name = "CollectionService GetAllTags", type = "Function" },
			{ id = "CollectionService GetInstanceAddedSignal", name = "CollectionService GetInstanceAddedSignal", type = "Event" },
			{ id = "CollectionService GetInstanceRemovedSignal", name = "CollectionService GetInstanceRemovedSignal", type = "Event" },
			{ id = "CollectionService TagAdded", name = "CollectionService TagAdded", type = "Event" },
			{ id = "CollectionService TagRemoved", name = "CollectionService TagRemoved", type = "Event" },
		}
	},
	{
		category = "ProximityPrompt",
		color = Color3.fromRGB(255, 100, 50),
		items = {
			{ id = "ProximityPrompt InputHoldBegin", name = "ProximityPrompt InputHoldBegin", type = "Method" },
			{ id = "ProximityPrompt InputHoldEnd", name = "ProximityPrompt InputHoldEnd", type = "Method" },
			{ id = "ProximityPrompt Triggered", name = "ProximityPrompt Triggered", type = "Event" },
			{ id = "ProximityPrompt TriggerEnded", name = "ProximityPrompt TriggerEnded", type = "Event" },
			{ id = "ProximityPrompt PromptButtonHoldBegan", name = "ProximityPrompt PromptButtonHoldBegan", type = "Event" },
			{ id = "ProximityPrompt PromptButtonHoldEnded", name = "ProximityPrompt PromptButtonHoldEnded", type = "Event" },
			{ id = "ProximityPrompt PromptShown", name = "ProximityPrompt PromptShown", type = "Event" },
			{ id = "ProximityPrompt PromptHidden", name = "ProximityPrompt PromptHidden", type = "Event" },
			{ id = "ProximityPrompt IndicatorShown", name = "ProximityPrompt IndicatorShown", type = "Event" },
			{ id = "ProximityPrompt IndicatorHidden", name = "ProximityPrompt IndicatorHidden", type = "Event" },
			{ id = "Instance to ProximityPrompt", name = "Instance to ProximityPrompt", type = "Function" },
		}
	},
	{
		category = "BadgeService",
		color = Color3.fromRGB(255, 180, 50),
		items = {
			{ id = "BadgeService AwardBadgeAsync", name = "BadgeService AwardBadgeAsync", type = "Method" },
			{ id = "BadgeService CheckUserBadgesAsync", name = "BadgeService CheckUserBadgesAsync", type = "Method" },
			{ id = "BadgeService GetBadgeInfoAsync", name = "BadgeService GetBadgeInfoAsync", type = "Method" },
			{ id = "BadgeService UserHasBadgeAsync", name = "BadgeService UserHasBadgeAsync", type = "Method" },
		}
	},
	{
		category = "GroupService",
		color = Color3.fromRGB(50, 150, 255),
		items = {
			{ id = "GroupService GetAlliesAsync", name = "GroupService GetAlliesAsync", type = "Method" },
			{ id = "GroupService GetEnemiesAsync", name = "GroupService GetEnemiesAsync", type = "Method" },
			{ id = "GroupService GetGroupInfoAsync", name = "GroupService GetGroupInfoAsync", type = "Method" },
			{ id = "GroupService GetGroupsAsync", name = "GroupService GetGroupsAsync", type = "Method" },
			{ id = "GroupService PromptJoinAsync", name = "GroupService PromptJoinAsync", type = "Method" },
		}
	},
	{
		category = "Pathfinding",
		color = Color3.fromRGB(50, 200, 100),
		items = {
			{ id = "Pathfinding CreatePath", name = "Pathfinding CreatePath", type = "Function" },
		}
	},
	{
		category = "TextChatService",
		color = Color3.fromRGB(200, 50, 255),
		items = {
			{ id = "TextChatService CanUserChatAsync", name = "TextChatService CanUserChatAsync", type = "Function" },
			{ id = "TextChatService CanUsersChatAsync", name = "TextChatService CanUsersChatAsync", type = "Function" },
			{ id = "TextChatService CanUsersDirectChatAsync", name = "TextChatService CanUsersDirectChatAsync", type = "Function" },
			{ id = "TextChatService DisplayBubble", name = "TextChatService DisplayBubble", type = "Method" },
			{ id = "TextChatService GetChatGroupsAsync", name = "TextChatService GetChatGroupsAsync", type = "Function" },
			{ id = "TextChatService BubbleDisplayed", name = "TextChatService BubbleDisplayed", type = "Event" },
			{ id = "TextChatService MessageReceived", name = "TextChatService MessageReceived", type = "Event" },
			{ id = "TextChatService SendingMessage", name = "TextChatService SendingMessage", type = "Event" },
			{ id = "Instance to TextChatService", name = "Instance to TextChatService", type = "Function" },
		}
	},
	{
		category = "Messaging",
		color = Color3.fromRGB(255, 150, 50),
		items = {
			{ id = "Messaging PublishAsync", name = "Messaging PublishAsync", type = "Method" },
			{ id = "Messaging SubscribeAsync", name = "Messaging SubscribeAsync", type = "Event" },
		}
	},
	{
		category = "SoundService",
		color = Color3.fromRGB(255, 100, 200),
		items = {
			{ id = "SoundService GetListener", name = "SoundService GetListener", type = "Function" },
			{ id = "SoundService GetMixerTime", name = "SoundService GetMixerTime", type = "Function" },
			{ id = "SoundService OpenAttenuationCurveEditor", name = "SoundService OpenAttenuationCurveEditor", type = "Method" },
			{ id = "SoundService OpenDirectionalCurveEditor", name = "SoundService OpenDirectionalCurveEditor", type = "Method" },
			{ id = "SoundService PlayLocalSound", name = "SoundService PlayLocalSound", type = "Method" },
			{ id = "SoundService SetListener", name = "SoundService SetListener", type = "Method" },
			{ id = "Instance to SoundService", name = "Instance to SoundService", type = "Function" },
		}
	},
	{
		category = "MemoryStore",
		color = Color3.fromRGB(50, 50, 150),
		items = {
			{ id = "MemoryStore GetHashMap", name = "MemoryStore GetHashMap", type = "Function" },
			{ id = "MemoryStore GetQueue", name = "MemoryStore GetQueue", type = "Function" },
			{ id = "MemoryStore GetSortedMap", name = "MemoryStore GetSortedMap", type = "Function" },
			{ id = "HashMap GetAsync", name = "HashMap GetAsync", type = "Method" },
			{ id = "HashMap ListItemsAsync", name = "HashMap ListItemsAsync", type = "Method" },
			{ id = "HashMap RemoveAsync", name = "HashMap RemoveAsync", type = "Method" },
			{ id = "HashMap SetAsync", name = "HashMap SetAsync", type = "Method" },
			{ id = "HashMap UpdateAsync", name = "HashMap UpdateAsync", type = "Method" },
			{ id = "Queue AddAsync", name = "Queue AddAsync", type = "Method" },
			{ id = "Queue GetSizeAsync", name = "Queue GetSizeAsync", type = "Method" },
			{ id = "Queue ReadAsync", name = "Queue ReadAsync", type = "Method" },
			{ id = "Queue RemoveAsync", name = "Queue RemoveAsync", type = "Method" },
			{ id = "SortedMap GetAsync", name = "SortedMap GetAsync", type = "Method" },
			{ id = "SortedMap GetRangeAsync", name = "SortedMap GetRangeAsync", type = "Method" },
			{ id = "SortedMap GetSizeAsync", name = "SortedMap GetSizeAsync", type = "Method" },
			{ id = "SortedMap RemoveAsync", name = "SortedMap RemoveAsync", type = "Method" },
			{ id = "SortedMap SetAsync", name = "SortedMap SetAsync", type = "Method" },
			{ id = "SortedMap UpdateAsync", name = "SortedMap UpdateAsync", type = "Method" },
		}
	},
	{
		category = "AssetService",
		color = Color3.fromRGB(150, 100, 255),
		items = {
			{ id = "AssetService ComposeDecalAsync", name = "AssetService ComposeDecalAsync", type = "Method" },
			{ id = "AssetService CreateAssetAsync", name = "AssetService CreateAssetAsync", type = "Method" },
			{ id = "AssetService CreateAssetVersionAsync", name = "AssetService CreateAssetVersionAsync", type = "Method" },
			{ id = "AssetService CreateDataModelContentAsync", name = "AssetService CreateDataModelContentAsync", type = "Method" },
			{ id = "AssetService CreateEditableImage", name = "AssetService CreateEditableImage", type = "Function" },
			{ id = "AssetService CreateEditableImageAsync", name = "AssetService CreateEditableImageAsync", type = "Method" },
			{ id = "AssetService CreateEditableMesh", name = "AssetService CreateEditableMesh", type = "Function" },
			{ id = "AssetService CreateEditableMeshAsync", name = "AssetService CreateEditableMeshAsync", type = "Method" },
			{ id = "AssetService CreateMeshPartAsync", name = "AssetService CreateMeshPartAsync", type = "Method" },
			{ id = "AssetService CreatePlaceAsync", name = "AssetService CreatePlaceAsync", type = "Method" },
			{ id = "AssetService CreateSurfaceAppearanceAsync", name = "AssetService CreateSurfaceAppearanceAsync", type = "Method" },
			{ id = "AssetService GetAssetIdsForPackageAsync", name = "AssetService GetAssetIdsForPackageAsync", type = "Method" },
			{ id = "AssetService GetAudioMetadataAsync", name = "AssetService GetAudioMetadataAsync", type = "Method" },
			{ id = "AssetService GetBundleDetailsAsync", name = "AssetService GetBundleDetailsAsync", type = "Method" },
			{ id = "AssetService GetGamePlacesAsync", name = "AssetService GetGamePlacesAsync", type = "Method" },
			{ id = "AssetService LoadAssetAsync", name = "AssetService LoadAssetAsync", type = "Method" },
			{ id = "AssetService PromptCreateAssetAsync", name = "AssetService PromptCreateAssetAsync", type = "Method" },
			{ id = "AssetService PromptImportAnimationClipFromVideoAsync", name = "AssetService PromptImportAnimationClipFromVideoAsync", type = "Method" },
			{ id = "AssetService SavePlaceAsync", name = "AssetService SavePlaceAsync", type = "Method" },
			{ id = "AssetService SearchAudioAsync", name = "AssetService SearchAudioAsync", type = "Method" },
			{ id = "Instance to AssetService", name = "Instance to AssetService", type = "Function" },
		}
	},
	{
		category = "UI",
		color = Color3.fromRGB(80, 180, 255),
		items = {
			{ id = "Instance to TextLabel", name = "Instance to TextLabel", type = "Function" },
			{ id = "Instance to TextButton", name = "Instance to TextButton", type = "Function" },
			{ id = "Instance to Frame", name = "Instance to Frame", type = "Function" },
			{ id = "Instance to ImageLabel", name = "Instance to ImageLabel", type = "Function" },
			{ id = "Instance to ImageButton", name = "Instance to ImageButton", type = "Function" },
			{ id = "Instance to ScreenGui", name = "Instance to ScreenGui", type = "Function" },
			{ id = "Instance to TextBox", name = "Instance to TextBox", type = "Function" },
			{ id = "Instance to ScrollingFrame", name = "Instance to ScrollingFrame", type = "Function" },
			{ id = "UI Activated", name = "UI Activated", type = "Event" },
			{ id = "UI Focused", name = "UI Focused", type = "Event" },
			{ id = "UI FocusLost", name = "UI FocusLost", type = "Event" },
			{ id = "UI InputBegan", name = "UI InputBegan", type = "Event" },
			{ id = "UI InputChanged", name = "UI InputChanged", type = "Event" },
			{ id = "UI InputEnded", name = "UI InputEnded", type = "Event" },
			{ id = "UI MouseEnter", name = "UI MouseEnter", type = "Event" },
			{ id = "UI MouseLeave", name = "UI MouseLeave", type = "Event" },
			{ id = "UI MouseMoved", name = "UI MouseMoved", type = "Event" },
			{ id = "UI MouseButton1Click", name = "UI MouseButton1Click", type = "Event" },
			{ id = "UI MouseButton1Down", name = "UI MouseButton1Down", type = "Event" },
			{ id = "UI MouseButton1Up", name = "UI MouseButton1Up", type = "Event" },
			{ id = "UI MouseButton2Click", name = "UI MouseButton2Click", type = "Event" },
			{ id = "UI MouseButton2Down", name = "UI MouseButton2Down", type = "Event" },
			{ id = "UI MouseButton2Up", name = "UI MouseButton2Up", type = "Event" },
			{ id = "UI MouseWheelForward", name = "UI MouseWheelForward", type = "Event" },
			{ id = "UI MouseWheelBackward", name = "UI MouseWheelBackward", type = "Event" },
			{ id = "UI TouchTap", name = "UI TouchTap", type = "Event" },
			{ id = "UI TouchSwipe", name = "UI TouchSwipe", type = "Event" },
			{ id = "UI TouchPan", name = "UI TouchPan", type = "Event" },
			{ id = "UI TouchPinch", name = "UI TouchPinch", type = "Event" },
			{ id = "UI TouchRotate", name = "UI TouchRotate", type = "Event" },
			{ id = "UI TouchLongPress", name = "UI TouchLongPress", type = "Event" },
			{ id = "UI SelectionGained", name = "UI SelectionGained", type = "Event" },
			{ id = "UI SelectionLost", name = "UI SelectionLost", type = "Event" },
			{ id = "UI SelectionChanged", name = "UI SelectionChanged", type = "Event" },
			{ id = "UI CaptureFocus", name = "UI CaptureFocus", type = "Method" },
			{ id = "UI IsFocused", name = "UI IsFocused", type = "Function" },
			{ id = "UI ReleaseFocus", name = "UI ReleaseFocus", type = "Method" },
			{ id = "UI GetScrollVelocity", name = "UI GetScrollVelocity", type = "Function" },
		}
	},
	{
		name = "Sounds",
		color = Color3.fromRGB(255, 150, 50),
		items = {
			{ id = "Sound Play", name = "Sound Play", type = "Method" },
			{ id = "Sound Pause", name = "Sound Pause", type = "Method" },
			{ id = "Sound Resume", name = "Sound Resume", type = "Method" },
			{ id = "Sound Stop", name = "Sound Stop", type = "Method" },
			{ id = "Sound DidLoop", name = "Sound DidLoop", type = "Event" },
			{ id = "Sound Ended", name = "Sound Ended", type = "Event" },
			{ id = "Sound Loaded", name = "Sound Loaded", type = "Event" },
			{ id = "Sound Paused", name = "Sound Paused", type = "Event" },
			{ id = "Sound Played", name = "Sound Played", type = "Event" },
			{ id = "Sound Resumed", name = "Sound Resumed", type = "Event" },
			{ id = "Sound Stopped", name = "Sound Stopped", type = "Event" },
		}
	}
}

function NodeMenu.prompt(parent, position, extraNodes, onSelect)
	local menuData = {}
	for _, cat in ipairs(NODES_DATA) do
		table.insert(menuData, cat)
	end
	if extraNodes then
		for _, cat in ipairs(extraNodes) do
			table.insert(menuData, cat)
		end
	end

	local overlay = Instance.new("TextButton")
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundTransparency = 1
	overlay.Text = ""
	overlay.ZIndex = 50
	overlay.Parent = parent

	local menu = Instance.new("Frame")
	menu.Size = UDim2.new(0, 220, 0, 300)
	menu.Position = UDim2.fromOffset(position.X, position.Y)
	menu.BackgroundColor3 = Color3.fromRGB(25, 32, 45)
	menu.BorderSizePixel = 0
	menu.ZIndex = 51
	menu.Parent = overlay
	makeCorner(menu, 6)
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(60, 80, 120)
	stroke.Parent = menu

	-- Search Bar
	local searchBg = Instance.new("Frame")
	searchBg.Size = UDim2.new(1, -16, 0, 28)
	searchBg.Position = UDim2.new(0, 8, 0, 8)
	searchBg.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
	searchBg.BorderSizePixel = 0
	searchBg.ZIndex = 52
	searchBg.Parent = menu
	makeCorner(searchBg, 4)

	local searchInput = Instance.new("TextBox")
	searchInput.Size = UDim2.new(1, -16, 1, 0)
	searchInput.Position = UDim2.new(0, 8, 0, 0)
	searchInput.BackgroundTransparency = 1
	searchInput.Text = ""
	searchInput.PlaceholderText = "Search..."
	searchInput.PlaceholderColor3 = Color3.fromRGB(90, 110, 140)
	searchInput.TextColor3 = Color3.fromRGB(220, 230, 255)
	searchInput.TextSize = 12
	searchInput.Font = Enum.Font.Gotham
	searchInput.TextXAlignment = Enum.TextXAlignment.Left
	searchInput.ClearTextOnFocus = false
	searchInput.ZIndex = 53
	searchInput.Parent = searchBg

	-- Scrollable List
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, 0, 1, -44)
	scroll.Position = UDim2.new(0, 0, 0, 44)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ZIndex = 52
	scroll.Parent = menu

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 4)
	layout.Parent = scroll

	local function close()
		overlay:Destroy()
	end
	overlay.MouseButton1Click:Connect(close)

	local TextService = game:GetService("TextService")

	local function renderList(filter)
		for _, child in scroll:GetChildren() do
			if child:IsA("GuiObject") then child:Destroy() end
		end

		filter = filter and string.lower(filter) or ""

		local layoutOrder = 0
		local maxTextWidth = 140 -- Minimum internal width for titles

		for _, cat in ipairs(menuData) do
			local validItems = {}
			for _, item in ipairs(cat.items) do
				if filter == "" or string.find(string.lower(item.name), filter) or string.find(string.lower(item.type), filter) then
					table.insert(validItems, item)
					
					-- Calculate width of this title
					local size = TextService:GetTextSize(item.name, 12, Enum.Font.GothamMedium, Vector2.new(1000, 26))
					if size.X > maxTextWidth then
						maxTextWidth = size.X
					end
				end
			end

			if #validItems > 0 then
				-- Category Header
				local header = Instance.new("TextLabel")
				header.Size = UDim2.new(1, -16, 0, 24)
				header.Position = UDim2.new(0, 8, 0, 0)
				header.BackgroundTransparency = 1
				header.Text = cat.category
				header.TextColor3 = cat.color
				header.TextSize = 12
				header.Font = Enum.Font.GothamBold
				header.TextXAlignment = Enum.TextXAlignment.Left
				header.LayoutOrder = layoutOrder
				header.ZIndex = 53
				header.Parent = scroll
				layoutOrder += 1
				
				local pad = Instance.new("UIPadding")
				pad.PaddingLeft = UDim.new(0, 12)
				pad.Parent = header

				-- Items
				for _, item in ipairs(validItems) do
					local btn = Instance.new("TextButton")
					btn.Size = UDim2.new(1, -16, 0, 26)
					btn.BackgroundColor3 = Color3.fromRGB(30, 38, 55)
					btn.BackgroundTransparency = filter == "" and 0 or 0.5
					btn.BorderSizePixel = 0
					btn.Text = item.name
					btn.TextColor3 = Color3.fromRGB(200, 215, 240)
					btn.TextSize = 12
					btn.Font = Enum.Font.GothamMedium
					btn.TextXAlignment = Enum.TextXAlignment.Left
					btn.AutoButtonColor = true
					btn.LayoutOrder = layoutOrder
					btn.ZIndex = 53
					btn.Parent = scroll
					makeCorner(btn, 4)
					layoutOrder += 1
					
					local btnPad = Instance.new("UIPadding")
					btnPad.PaddingLeft = UDim.new(0, 8)
					btnPad.Parent = btn

					-- Type Badge
					local badge = Instance.new("TextLabel")
					badge.Size = UDim2.new(0, 45, 0, 16)
					badge.Position = UDim2.new(1, -50, 0.5, -8)
					badge.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
					badge.BorderSizePixel = 0
					badge.Text = item.type
					badge.TextColor3 = Color3.fromRGB(120, 140, 170)
					badge.TextSize = 9
					badge.Font = Enum.Font.GothamBold
					badge.ZIndex = 54
					badge.Parent = btn
					makeCorner(badge, 3)

					btn.MouseButton1Click:Connect(function()
						close()
						onSelect(item.id)
					end)
				end
			end
		end
		
		-- Update menu width based on maxTextWidth + padding + badge area
		local finalWidth = math.clamp(maxTextWidth + 80, 220, 500)
		menu.Size = UDim2.new(0, finalWidth, 0, 300)
	end

	searchInput:GetPropertyChangedSignal("Text"):Connect(function()
		renderList(searchInput.Text)
	end)

	renderList("")

	task.defer(function()
		searchInput:CaptureFocus()
	end)
end

return NodeMenu
