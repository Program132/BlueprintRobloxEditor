local RunService = game:GetService("RunService")

if not RunService:IsEdit() then
	return
end

-- Import backend modules
local Shared = script.Parent:WaitForChild("Shared")
local Graph  = require(Shared.Graph)
local Block  = require(Shared.Block)

-- Import plugin classes
local FileManager = require(script.FileManager)

-- Import UI classes
local UI      = script.ui
local TopBar  = require(UI.TopBar)
local Canvas  = require(UI.Canvas)
local Sidebar = require(UI.Sidebar)
local Modal   = require(UI.Modal)
local ScriptModal = require(UI.ScriptModal)
local ChoiceModal = require(UI.ChoiceModal)
local NodeMenu = require(UI.NodeMenu)
local NodeComponent = require(UI.NodeComponent)
local FunctionEntry = require(Shared.nodes.FunctionEntry)
local FunctionReturn = require(Shared.nodes.FunctionReturn)
local FunctionCall = require(Shared.nodes.FunctionCall)

local Nodes = {
	["Start Event"] = require(Shared.nodes.events.Start),
	["Return"]      = require(Shared.nodes.Return),
	["Print"]       = require(Shared.nodes.Print),
	["Warn"]        = require(Shared.nodes.Warn),
	["Error"]       = require(Shared.nodes.Error),
	["Add"]         = require(Shared.nodes.math.Add),
	["Abs"]         = require(Shared.nodes.math.Abs),
	["Sin"]         = require(Shared.nodes.math.Sin),
	["Cos"]         = require(Shared.nodes.math.Cos),
	["Tan"]         = require(Shared.nodes.math.Tan),
	["Asin"]        = require(Shared.nodes.math.Asin),
	["Acos"]        = require(Shared.nodes.math.Acos),
	["Atan"]        = require(Shared.nodes.math.Atan),
	["Atan2"]       = require(Shared.nodes.math.Atan2),
	["Sinh"]        = require(Shared.nodes.math.Sinh),
	["Cosh"]        = require(Shared.nodes.math.Cosh),
	["Tanh"]        = require(Shared.nodes.math.Tanh),
	["Deg"]         = require(Shared.nodes.math.Deg),
	["Rad"]         = require(Shared.nodes.math.Rad),
	["Sqrt"]        = require(Shared.nodes.math.Sqrt),
	["Floor"]       = require(Shared.nodes.math.Floor),
	["Ceil"]        = require(Shared.nodes.math.Ceil),
	["Fmod"]        = require(Shared.nodes.math.Fmod),
	["Pow"]         = require(Shared.nodes.math.Pow),
	["Exp"]         = require(Shared.nodes.math.Exp),
	["Log"]         = require(Shared.nodes.math.Log),
	["Log10"]       = require(Shared.nodes.math.Log10),
	["Ldexp"]       = require(Shared.nodes.math.Ldexp),
	["Min"]         = require(Shared.nodes.math.Min),
	["Max"]         = require(Shared.nodes.math.Max),
	["Pi"]          = require(Shared.nodes.math.Pi),
	["Huge"]        = require(Shared.nodes.math.Huge),
	["Random"]      = require(Shared.nodes.math.Random),
	["Random Seed"] = require(Shared.nodes.math.RandomSeed),
	["String Lower"] = require(Shared.nodes.string.Lower),
	["String Upper"] = require(Shared.nodes.string.Upper),
	["String Len"]   = require(Shared.nodes.string.Len),
	["String Reverse"] = require(Shared.nodes.string.Reverse),
	["String Sub"]   = require(Shared.nodes.string.Sub),
	["String Rep"]   = require(Shared.nodes.string.Rep),
	["String Split"] = require(Shared.nodes.string.Split),
	["String Find"]  = require(Shared.nodes.string.Find),
	["String GSub"]  = require(Shared.nodes.string.GSub),
	["String Match"] = require(Shared.nodes.string.Match),
	["String Byte"]  = require(Shared.nodes.string.Byte),
	["String Char"]  = require(Shared.nodes.string.Char),
	["String Format"] = require(Shared.nodes.string.Format),
	["Boolean And"]  = require(Shared.nodes.boolean.And),
	["Boolean Or"]   = require(Shared.nodes.boolean.Or),
	["Boolean Not"]  = require(Shared.nodes.boolean.Not),
	["Boolean Equal"] = require(Shared.nodes.boolean.Equal),
	["Boolean NotEqual"] = require(Shared.nodes.boolean.NotEqual),
	["Boolean GreaterThan"] = require(Shared.nodes.boolean.GreaterThan),
	["Boolean GreaterOrEqual"] = require(Shared.nodes.boolean.GreaterOrEqual),
	["Boolean LessThan"] = require(Shared.nodes.boolean.LessThan),
	["Boolean LessOrEqual"] = require(Shared.nodes.boolean.LessOrEqual),
	["Table Insert"] = require(Shared.nodes.tables:WaitForChild("Insert")),
	["Table Remove"] = require(Shared.nodes.tables:WaitForChild("Rem")),
	["Table Clear"]  = require(Shared.nodes.tables:WaitForChild("Clear")),
	["Table Clone"]  = require(Shared.nodes.tables:WaitForChild("Clone")),
	["Table Concat"] = require(Shared.nodes.tables:WaitForChild("Concat")),
	["Table Find"]   = require(Shared.nodes.tables:WaitForChild("Find")),
	["Table Freeze"] = require(Shared.nodes.tables:WaitForChild("Freeze")),
	["Table Is Frozen"] = require(Shared.nodes.tables:WaitForChild("IsFrozen")),
	["Table Sort"]   = require(Shared.nodes.tables:WaitForChild("Sort")),
	["Table Unpack"] = require(Shared.nodes.tables:WaitForChild("Unpack")),
	["Table Move"]   = require(Shared.nodes.tables:WaitForChild("Move")),
	["Get Variable"] = require(Shared.nodes.variables.Get),
	["Set Variable"] = require(Shared.nodes.variables.Set),
	["If"]          = require(Shared.nodes.control.If),
	["While"]       = require(Shared.nodes.control.While),
	["pcall"]       = require(Shared.nodes.control.Pcall),
	["For"]         = require(Shared.nodes.control.For),
	["Require"]     = require(Shared.nodes.modules.Require),
	["Module Call"] = require(Shared.nodes.modules.ModuleCall),
	["Task Wait"]   = require(Shared.nodes.task.Wait),
	["Task Spawn"]  = require(Shared.nodes.task.Spawn),
	["Task Defer"]  = require(Shared.nodes.task.Defer),
	["Task Delay"]  = require(Shared.nodes.task.Delay),
	["Task Synchronize"] = require(Shared.nodes.task.Synchronize),
	["Task Desynchronize"] = require(Shared.nodes.task.Desynchronize),
	["Task Cancel"] = require(Shared.nodes.task.Cancel),
	["OS Clock"]    = require(Shared.nodes.os:WaitForChild("Clock")),
	["OS Time"]     = require(Shared.nodes.os:WaitForChild("Time")),
	["OS Difftime"] = require(Shared.nodes.os:WaitForChild("Difftime")),
	["OS Date"]     = require(Shared.nodes.os:WaitForChild("Date")),
	["DateTime Now"] = require(Shared.nodes.datetime:WaitForChild("Now")),
	["DateTime FromUnixTimestamp"] = require(Shared.nodes.datetime:WaitForChild("FromUnixTimestamp")),
	["DateTime FromIsoDate"] = require(Shared.nodes.datetime:WaitForChild("FromIsoDate")),
	["DateTime ToLocalTime"] = require(Shared.nodes.datetime:WaitForChild("ToLocalTime")),
	["DateTime ToIsoDate"] = require(Shared.nodes.datetime:WaitForChild("ToIsoDate")),
	["DateTime FormatLocalTime"] = require(Shared.nodes.datetime:WaitForChild("FormatLocalTime")),
	["DateTime UnixTimestamp"] = require(Shared.nodes.datetime:WaitForChild("UnixTimestamp")),
	["Enum KeyCode"] = require(Shared.nodes.enums:WaitForChild("KeyCode")),
	["Enum UserInputType"] = require(Shared.nodes.enums:WaitForChild("UserInputType")),
	["Enum UserInputState"] = require(Shared.nodes.enums:WaitForChild("UserInputState")),
	["Enum PredictionMode"] = require(Shared.nodes.enums:WaitForChild("PredictionMode")),
	["Enum StepFrequency"] = require(Shared.nodes.enums:WaitForChild("StepFrequency")),
	["Enum RunState"] = require(Shared.nodes.enums:WaitForChild("RunState")),
	["Enum Material"] = require(Shared.nodes.enums:WaitForChild("Material")),
	["Enum PartType"] = require(Shared.nodes.enums:WaitForChild("PartType")),
	["Enum HumanoidStateType"] = require(Shared.nodes.enums:WaitForChild("HumanoidStateType")),
	["Enum EasingDirection"] = require(Shared.nodes.enums:WaitForChild("EasingDirection")),
	["Enum EasingStyle"] = require(Shared.nodes.enums:WaitForChild("EasingStyle")),
	["Enum CameraType"] = require(Shared.nodes.enums:WaitForChild("CameraType")),
	["Enum CameraMode"] = require(Shared.nodes.enums:WaitForChild("CameraMode")),
	["Enum ChatRestrictionStatus"] = require(Shared.nodes.enums:WaitForChild("ChatRestrictionStatus")),
	["Enum DevCameraOcclusionMode"] = require(Shared.nodes.enums:WaitForChild("DevCameraOcclusionMode")),
	["Enum DevComputerCameraMovementMode"] = require(Shared.nodes.enums:WaitForChild("DevComputerCameraMovementMode")),
	["Enum DevComputerMovementMode"] = require(Shared.nodes.enums:WaitForChild("DevComputerMovementMode")),
	["Enum DevTouchCameraMovementMode"] = require(Shared.nodes.enums:WaitForChild("DevTouchCameraMovementMode")),
	["Enum DevTouchMovementMode"] = require(Shared.nodes.enums:WaitForChild("DevTouchMovementMode")),
	["Enum InfoType"] = require(Shared.nodes.enums:WaitForChild("InfoType")),
	["Enum CurrencyType"] = require(Shared.nodes.enums:WaitForChild("CurrencyType")),
	["Enum CoreGuiType"] = require(Shared.nodes.enums:WaitForChild("CoreGuiType")),
	["Enum RtlTextSupport"] = require(Shared.nodes.enums:WaitForChild("RtlTextSupport")),
	["Enum ScreenOrientation"] = require(Shared.nodes.enums:WaitForChild("ScreenOrientation")),
	["Enum VirtualCursorMode"] = require(Shared.nodes.enums:WaitForChild("VirtualCursorMode")),
	["Enum WebStreamClientType"] = require(Shared.nodes.enums:WaitForChild("WebStreamClientType")),
	["Enum HttpContentType"] = require(Shared.nodes.enums:WaitForChild("HttpContentType")),
	["Enum LightingStyle"] = require(Shared.nodes.enums:WaitForChild("LightingStyle")),
	["Enum RolloutState"] = require(Shared.nodes.enums:WaitForChild("RolloutState")),
	["Enum TeleportResult"] = require(Shared.nodes.enums:WaitForChild("TeleportResult")),
	["Enum DataStoreRequestType"] = require(Shared.nodes.enums:WaitForChild("DataStoreRequestType")),
	["Enum SortDirection"] = require(Shared.nodes.enums:WaitForChild("SortDirection")),
	["Color3 fromRGB"] = require(Shared.nodes.color:WaitForChild("FromRGB")),
	["Color3 fromHSV"] = require(Shared.nodes.color:WaitForChild("FromHSV")),
	["Color3 fromHex"] = require(Shared.nodes.color:WaitForChild("FromHex")),
	["Color3 Lerp"] = require(Shared.nodes.color:WaitForChild("Lerp")),
	["Vector2 new"] = require(Shared.nodes.vector2:WaitForChild("New")),
	["Vector2 Lerp"] = require(Shared.nodes.vector2:WaitForChild("Lerp")),
	["Vector2 Dot"] = require(Shared.nodes.vector2:WaitForChild("Dot")),
	["Vector2 Cross"] = require(Shared.nodes.vector2:WaitForChild("Cross")),
	["Vector2 Abs"] = require(Shared.nodes.vector2:WaitForChild("Abs")),
	["Vector2 Ceil"] = require(Shared.nodes.vector2:WaitForChild("Ceil")),
	["Vector2 Floor"] = require(Shared.nodes.vector2:WaitForChild("Floor")),
	["Vector2 Sign"] = require(Shared.nodes.vector2:WaitForChild("Sign")),
	["Vector2 Angle"] = require(Shared.nodes.vector2:WaitForChild("Angle")),
	["Vector2 Max"] = require(Shared.nodes.vector2:WaitForChild("Max")),
	["Vector2 Min"] = require(Shared.nodes.vector2:WaitForChild("Min")),
	["Vector2 FuzzyEq"] = require(Shared.nodes.vector2:WaitForChild("FuzzyEq")),
	["Vector3 new"] = require(Shared.nodes.vector3:WaitForChild("New")),
	["Vector3 Abs"] = require(Shared.nodes.vector3:WaitForChild("Abs")),
	["Vector3 Ceil"] = require(Shared.nodes.vector3:WaitForChild("Ceil")),
	["Vector3 Floor"] = require(Shared.nodes.vector3:WaitForChild("Floor")),
	["Vector3 Sign"] = require(Shared.nodes.vector3:WaitForChild("Sign")),
	["Vector3 Dot"] = require(Shared.nodes.vector3:WaitForChild("Dot")),
	["Vector3 Cross"] = require(Shared.nodes.vector3:WaitForChild("Cross")),
	["Vector3 Lerp"] = require(Shared.nodes.vector3:WaitForChild("Lerp")),
	["Vector3 Angle"] = require(Shared.nodes.vector3:WaitForChild("Angle")),
	["Vector3 Max"] = require(Shared.nodes.vector3:WaitForChild("Max")),
	["Vector3 Min"] = require(Shared.nodes.vector3:WaitForChild("Min")),
	["Vector3 FuzzyEq"] = require(Shared.nodes.vector3:WaitForChild("FuzzyEq")),
	["Vector3 zero"] = require(Shared.nodes.vector3:WaitForChild("Zero")),
	["game"] = require(Shared.nodes.globals:WaitForChild("GameGlobal")),
	["workspace"] = require(Shared.nodes.globals:WaitForChild("WorkspaceGlobal")),
	["script"] = require(Shared.nodes.globals:WaitForChild("ScriptGlobal")),
	["Vector3 one"] = require(Shared.nodes.vector3:WaitForChild("One")),
	["Vector3 xAxis"] = require(Shared.nodes.vector3:WaitForChild("XAxis")),
	["Vector3 yAxis"] = require(Shared.nodes.vector3:WaitForChild("YAxis")),
	["Vector3 zAxis"] = require(Shared.nodes.vector3:WaitForChild("ZAxis")),
	["UDim new"] = require(Shared.nodes.udim:WaitForChild("New")),
	["UDim2 new"] = require(Shared.nodes.udim2:WaitForChild("New")),
	["UDim2 fromScale"] = require(Shared.nodes.udim2:WaitForChild("FromScale")),
	["UDim2 fromOffset"] = require(Shared.nodes.udim2:WaitForChild("FromOffset")),
	["UDim2 Lerp"] = require(Shared.nodes.udim2:WaitForChild("Lerp")),
	["CFrame new"] = require(Shared.nodes.cframe:WaitForChild("New")),
	["CFrame new XYZ"] = require(Shared.nodes.cframe:WaitForChild("NewXYZ")),
	["CFrame lookAt"] = require(Shared.nodes.cframe:WaitForChild("LookAt")),
	["CFrame Angles"] = require(Shared.nodes.cframe:WaitForChild("Angles")),
	["CFrame Inverse"] = require(Shared.nodes.cframe:WaitForChild("Inverse")),
	["CFrame Lerp"] = require(Shared.nodes.cframe:WaitForChild("Lerp")),
	["CFrame ToWorldSpace"] = require(Shared.nodes.cframe:WaitForChild("ToWorldSpace")),
	["CFrame ToObjectSpace"] = require(Shared.nodes.cframe:WaitForChild("ToObjectSpace")),
	["CFrame PointToWorldSpace"] = require(Shared.nodes.cframe:WaitForChild("PointToWorldSpace")),
	["CFrame PointToObjectSpace"] = require(Shared.nodes.cframe:WaitForChild("PointToObjectSpace")),
	["Subtract"] = require(Shared.nodes.math:WaitForChild("Subtract")),
	["Multiply"] = require(Shared.nodes.math:WaitForChild("Multiply")),
	["Divide"] = require(Shared.nodes.math:WaitForChild("Divide")),
	["Concat"] = require(Shared.nodes.string:WaitForChild("Concat")),
	["TweenInfo new"] = require(Shared.nodes.tween:WaitForChild("TweenInfoNew")),
	["Tween Create"] = require(Shared.nodes.tween:WaitForChild("Create")),
	["Tween Play"] = require(Shared.nodes.tween:WaitForChild("Play")),
	["Instance Workspace Object"] = require(Shared.nodes.instances:WaitForChild("WorkspaceObject")),
	["Get Service"] = require(Shared.nodes.instances:WaitForChild("GetService")),
	["Instance Child"] = require(Shared.nodes.instances:WaitForChild("InstanceChild")),
	["Instance Get Parent"] = require(Shared.nodes.instances:WaitForChild("GetParent")),
	["Instance Find First Child"] = require(Shared.nodes.instances:WaitForChild("FindFirstChild")),
	["Instance Wait For Child"] = require(Shared.nodes.instances:WaitForChild("WaitForChild")),
	["Instance Clone"] = require(Shared.nodes.instances:WaitForChild("Clone")),
	["Instance Destroy"] = require(Shared.nodes.instances:WaitForChild("Destroy")),
	["Instance Clear All Children"] = require(Shared.nodes.instances:WaitForChild("ClearAllChildren")),
	["Instance Get Children"] = require(Shared.nodes.instances:WaitForChild("GetChildren")),
	["Instance Get Descendants"] = require(Shared.nodes.instances:WaitForChild("GetDescendants")),
	["Instance Get Full Name"] = require(Shared.nodes.instances:WaitForChild("GetFullName")),
	["Instance Is A"] = require(Shared.nodes.instances:WaitForChild("IsA")),
	["Instance Has Tag"] = require(Shared.nodes.instances:WaitForChild("HasTag")),
	["Instance Add Tag"] = require(Shared.nodes.instances:WaitForChild("AddTag")),
	["Instance Remove Tag"] = require(Shared.nodes.instances:WaitForChild("RemoveTag")),
	["Instance Get Attribute"] = require(Shared.nodes.instances:WaitForChild("GetAttribute")),
	["Instance Set Attribute"] = require(Shared.nodes.instances:WaitForChild("SetAttribute")),
	["Instance Is Ancestor Of"] = require(Shared.nodes.instances:WaitForChild("IsAncestorOf")),
	["Instance Is Descendant Of"] = require(Shared.nodes.instances:WaitForChild("IsDescendantOf")),
	["Instance Find First Ancestor"] = require(Shared.nodes.instances:WaitForChild("FindFirstAncestor")),
	["Instance Find First Ancestor Of Class"] = require(Shared.nodes.instances:WaitForChild("FindFirstAncestorOfClass")),
	["Instance Find First Ancestor Which Is A"] = require(Shared.nodes.instances:WaitForChild("FindFirstAncestorWhichIsA")),
	["Instance Find First Child Of Class"] = require(Shared.nodes.instances:WaitForChild("FindFirstChildOfClass")),
	["Instance Find First Child Which Is A"] = require(Shared.nodes.instances:WaitForChild("FindFirstChildWhichIsA")),
	["Instance Get Property"] = require(Shared.nodes.instances:WaitForChild("GetProperty")),
	["Instance Set Property"] = require(Shared.nodes.instances:WaitForChild("SetProperty")),
	["Tween Pause"] = require(Shared.nodes.tween:WaitForChild("Pause")),
	["Tween Cancel"] = require(Shared.nodes.tween:WaitForChild("Cancel")),

	-- Conversion nodes
	["Instance To BasePart"] = require(Shared.nodes.conversions:WaitForChild("InstanceToBasePart")),
	["Instance To Part"] = require(Shared.nodes.conversions:WaitForChild("InstanceToPart")),
	["Instance To Model"] = require(Shared.nodes.conversions:WaitForChild("InstanceToModel")),
	["Instance To Folder"] = require(Shared.nodes.conversions:WaitForChild("InstanceToFolder")),
	["Instance To MeshPart"] = require(Shared.nodes.conversions:WaitForChild("InstanceToMeshPart")),
	["Instance To Humanoid"] = require(Shared.nodes.conversions:WaitForChild("InstanceToHumanoid")),
	["Instance To Player"] = require(Shared.nodes.conversions:WaitForChild("InstanceToPlayer")),
	["Instance To Sound"] = require(Shared.nodes.conversions:WaitForChild("InstanceToSound")),
	["Instance To Tool"] = require(Shared.nodes.conversions:WaitForChild("InstanceToTool")),
	["Instance To StarterGui"] = require(Shared.nodes.conversions:WaitForChild("InstanceToStarterGui")),
	["Instance To Camera"] = require(Shared.nodes.conversions:WaitForChild("InstanceToCamera")),
	["ToString"] = require(Shared.nodes.conversions:WaitForChild("ToString")),
	["ToNumber"] = require(Shared.nodes.conversions:WaitForChild("ToNumber")),

	-- Players nodes
	["Get Local Player"] = require(Shared.nodes.players:WaitForChild("LocalPlayer")),
	["Get Player From Character"] = require(Shared.nodes.players:WaitForChild("GetPlayerFromCharacter")),
	["Event Player Added"] = require(Shared.nodes.players:WaitForChild("PlayerAdded")),
	["Event Player Removing"] = require(Shared.nodes.players:WaitForChild("PlayerRemoving")),
	["Event CharacterAdded"] = require(Shared.nodes.players:WaitForChild("CharacterAdded")),
	["Event CharacterAppearanceLoaded"] = require(Shared.nodes.players:WaitForChild("CharacterAppearanceLoaded")),
	["Event CharacterRemoving"] = require(Shared.nodes.players:WaitForChild("CharacterRemoving")),
	["Event Chatted"] = require(Shared.nodes.players:WaitForChild("Chatted")),
	["Event Idled"] = require(Shared.nodes.players:WaitForChild("Idled")),
	["Event OnTeleport"] = require(Shared.nodes.players:WaitForChild("OnTeleport")),
	["Get Name From UserIdAsync"] = require(Shared.nodes.players:WaitForChild("GetNameFromUserIdAsync")),
	["Get UserId FromNameAsync"] = require(Shared.nodes.players:WaitForChild("GetUserIdFromNameAsync")),
	
	-- Tools nodes
	["Event Tool Activated"] = require(Shared.nodes.tools:WaitForChild("Activated")),
	["Event Tool Deactivated"] = require(Shared.nodes.tools:WaitForChild("Deactivated")),
	["Event Tool Equipped"] = require(Shared.nodes.tools:WaitForChild("Equipped")),
	["Event Tool Unequipped"] = require(Shared.nodes.tools:WaitForChild("Unequipped")),
	["Activate Tool"] = require(Shared.nodes.tools:WaitForChild("Activate")),
	["Deactivate Tool"] = require(Shared.nodes.tools:WaitForChild("Deactivate")),

	-- StarterGui nodes
	["StarterGui GetCore"] = require(Shared.nodes.startergui:WaitForChild("GetCore")),
	["StarterGui GetCoreGuiEnabled"] = require(Shared.nodes.startergui:WaitForChild("GetCoreGuiEnabled")),
	["StarterGui SetCore"] = require(Shared.nodes.startergui:WaitForChild("SetCore")),
	["StarterGui SetCoreGuiEnabled"] = require(Shared.nodes.startergui:WaitForChild("SetCoreGuiEnabled")),

	-- Ray nodes
	["Ray new"] = require(Shared.nodes.ray:WaitForChild("New")),
	["Ray ClosestPoint"] = require(Shared.nodes.ray:WaitForChild("ClosestPoint")),
	["Ray Distance"] = require(Shared.nodes.ray:WaitForChild("Distance")),
	["Ray Unit"] = require(Shared.nodes.ray:WaitForChild("Unit")),
	["Ray Origin"] = require(Shared.nodes.ray:WaitForChild("Origin")),
	["Ray Direction"] = require(Shared.nodes.ray:WaitForChild("Direction")),

	-- Marketplace nodes
	["MarketplaceService GetProductInfoAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetProductInfoAsync")),
	["MarketplaceService UserOwnsGamePassAsync"] = require(Shared.nodes.marketplace:WaitForChild("UserOwnsGamePassAsync")),
	["MarketplaceService PlayerOwnsAssetAsync"] = require(Shared.nodes.marketplace:WaitForChild("PlayerOwnsAssetAsync")),
	["MarketplaceService PlayerOwnsBundleAsync"] = require(Shared.nodes.marketplace:WaitForChild("PlayerOwnsBundleAsync")),
	["MarketplaceService PromptPurchase"] = require(Shared.nodes.marketplace:WaitForChild("PromptPurchase")),
	["MarketplaceService PromptProductPurchase"] = require(Shared.nodes.marketplace:WaitForChild("PromptProductPurchase")),
	["MarketplaceService PromptGamePassPurchase"] = require(Shared.nodes.marketplace:WaitForChild("PromptGamePassPurchase")),
	["MarketplaceService PromptBundlePurchase"] = require(Shared.nodes.marketplace:WaitForChild("PromptBundlePurchase")),
	["MarketplaceService PromptBulkPurchase"] = require(Shared.nodes.marketplace:WaitForChild("PromptBulkPurchase")),
	["MarketplaceService PromptSubscriptionPurchase"] = require(Shared.nodes.marketplace:WaitForChild("PromptSubscriptionPurchase")),
	["MarketplaceService PromptRobloxSubscriptionPurchase"] = require(Shared.nodes.marketplace:WaitForChild("PromptRobloxSubscriptionPurchase")),
	["MarketplaceService PromptCancelSubscription"] = require(Shared.nodes.marketplace:WaitForChild("PromptCancelSubscription")),
	["MarketplaceService GetDeveloperProductsAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetDeveloperProductsAsync")),
	["MarketplaceService GetSubscriptionProductInfoAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetSubscriptionProductInfoAsync")),
	["MarketplaceService GetRobloxSubscriptionDetailsAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetRobloxSubscriptionDetailsAsync")),
	["MarketplaceService GetUsersPriceLevelsAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetUsersPriceLevelsAsync")),
	["MarketplaceService GetUserSubscriptionDetailsAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetUserSubscriptionDetailsAsync")),
	["MarketplaceService GetUserSubscriptionPaymentHistoryAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetUserSubscriptionPaymentHistoryAsync")),
	["MarketplaceService GetUserSubscriptionStatusAsync"] = require(Shared.nodes.marketplace:WaitForChild("GetUserSubscriptionStatusAsync")),
	["MarketplaceService RankProductsAsync"] = require(Shared.nodes.marketplace:WaitForChild("RankProductsAsync")),
	["MarketplaceService RecommendTopProductsAsync"] = require(Shared.nodes.marketplace:WaitForChild("RecommendTopProductsAsync")),
	["MarketplaceService PromptPurchaseFinished"] = require(Shared.nodes.marketplace:WaitForChild("PromptPurchaseFinished")),
	["MarketplaceService PromptProductPurchaseFinished"] = require(Shared.nodes.marketplace:WaitForChild("PromptProductPurchaseFinished")),
	["MarketplaceService PromptGamePassPurchaseFinished"] = require(Shared.nodes.marketplace:WaitForChild("PromptGamePassPurchaseFinished")),
	["MarketplaceService PromptBundlePurchaseFinished"] = require(Shared.nodes.marketplace:WaitForChild("PromptBundlePurchaseFinished")),
	["MarketplaceService PromptPremiumPurchaseFinished"] = require(Shared.nodes.marketplace:WaitForChild("PromptPremiumPurchaseFinished")),
	["MarketplaceService PromptSubscriptionPurchaseFinished"] = require(Shared.nodes.marketplace:WaitForChild("PromptSubscriptionPurchaseFinished")),
	["MarketplaceService PromptRobloxSubscriptionPurchaseFinished"] = require(Shared.nodes.marketplace:WaitForChild("PromptRobloxSubscriptionPurchaseFinished")),

	-- TeleportService nodes
	["TeleportService GetArrivingTeleportGui"] = require(Shared.nodes.teleportservice:WaitForChild("GetArrivingTeleportGui")),
	["TeleportService GetLocalPlayerTeleportData"] = require(Shared.nodes.teleportservice:WaitForChild("GetLocalPlayerTeleportData")),
	["TeleportService GetTeleportSetting"] = require(Shared.nodes.teleportservice:WaitForChild("GetTeleportSetting")),
	["TeleportService GetPlayerPlaceInstanceAsync"] = require(Shared.nodes.teleportservice:WaitForChild("GetPlayerPlaceInstanceAsync")),
	["TeleportService PromptExperienceDetailsAsync"] = require(Shared.nodes.teleportservice:WaitForChild("PromptExperienceDetailsAsync")),
	["TeleportService ReserveServer"] = require(Shared.nodes.teleportservice:WaitForChild("ReserveServer")),
	["TeleportService SetTeleportGui"] = require(Shared.nodes.teleportservice:WaitForChild("SetTeleportGui")),
	["TeleportService SetTeleportSetting"] = require(Shared.nodes.teleportservice:WaitForChild("SetTeleportSetting")),
	["TeleportService TeleportAsync"] = require(Shared.nodes.teleportservice:WaitForChild("TeleportAsync")),
	["Event TeleportService LocalPlayerArrivedFromTeleport"] = require(Shared.nodes.teleportservice:WaitForChild("LocalPlayerArrivedFromTeleport")),
	["Event TeleportService TeleportInitFailed"] = require(Shared.nodes.teleportservice:WaitForChild("TeleportInitFailed")),

	-- DataStoreService nodes
	["DataStoreService GetDataStore"] = require(Shared.nodes.datastore:WaitForChild("GetDataStore")),
	["DataStoreService GetGlobalDataStore"] = require(Shared.nodes.datastore:WaitForChild("GetGlobalDataStore")),
	["DataStoreService GetOrderedDataStore"] = require(Shared.nodes.datastore:WaitForChild("GetOrderedDataStore")),
	["DataStoreService GetRequestBudgetForRequestType"] = require(Shared.nodes.datastore:WaitForChild("GetRequestBudgetForRequestType")),
	["DataStoreService ListDataStoresAsync"] = require(Shared.nodes.datastore:WaitForChild("ListDataStoresAsync")),
	["DataStoreService SetRateLimitForRequestType"] = require(Shared.nodes.datastore:WaitForChild("SetRateLimitForRequestType")),
	["DataStore GetVersionAsync"] = require(Shared.nodes.datastore:WaitForChild("GetVersionAsync")),
	["DataStore GetVersionAtTimeAsync"] = require(Shared.nodes.datastore:WaitForChild("GetVersionAtTimeAsync")),
	["DataStore ListKeysAsync"] = require(Shared.nodes.datastore:WaitForChild("ListKeysAsync")),
	["DataStore ListVersionsAsync"] = require(Shared.nodes.datastore:WaitForChild("ListVersionsAsync")),
	["DataStore GetAsync"] = require(Shared.nodes.datastore:WaitForChild("GetAsync")),
	["DataStore IncrementAsync"] = require(Shared.nodes.datastore:WaitForChild("IncrementAsync")),
	["DataStore RemoveAsync"] = require(Shared.nodes.datastore:WaitForChild("RemoveAsync")),
	["DataStore SetAsync"] = require(Shared.nodes.datastore:WaitForChild("SetAsync")),
	["DataStore UpdateAsync"] = require(Shared.nodes.datastore:WaitForChild("UpdateAsync")),

	-- UserInputService nodes
	["UserInputService CreateVirtualInput"] = require(Shared.nodes.userinputservice:WaitForChild("CreateVirtualInput")),
	["UserInputService GamepadSupports"] = require(Shared.nodes.userinputservice:WaitForChild("GamepadSupports")),
	["UserInputService GetConnectedGamepads"] = require(Shared.nodes.userinputservice:WaitForChild("GetConnectedGamepads")),
	["UserInputService GetDeviceAcceleration"] = require(Shared.nodes.userinputservice:WaitForChild("GetDeviceAcceleration")),
	["UserInputService GetDeviceGravity"] = require(Shared.nodes.userinputservice:WaitForChild("GetDeviceGravity")),
	["UserInputService GetDeviceRotation"] = require(Shared.nodes.userinputservice:WaitForChild("GetDeviceRotation")),
	["UserInputService GetFocusedTextBox"] = require(Shared.nodes.userinputservice:WaitForChild("GetFocusedTextBox")),
	["UserInputService GetGamepadConnected"] = require(Shared.nodes.userinputservice:WaitForChild("GetGamepadConnected")),
	["UserInputService GetGamepadState"] = require(Shared.nodes.userinputservice:WaitForChild("GetGamepadState")),
	["UserInputService GetImageForKeyCode"] = require(Shared.nodes.userinputservice:WaitForChild("GetImageForKeyCode")),
	["UserInputService GetKeysPressed"] = require(Shared.nodes.userinputservice:WaitForChild("GetKeysPressed")),
	["UserInputService GetLastInputType"] = require(Shared.nodes.userinputservice:WaitForChild("GetLastInputType")),
	["UserInputService GetMouseButtonsPressed"] = require(Shared.nodes.userinputservice:WaitForChild("GetMouseButtonsPressed")),
	["UserInputService GetMouseDelta"] = require(Shared.nodes.userinputservice:WaitForChild("GetMouseDelta")),
	["UserInputService GetMouseLocation"] = require(Shared.nodes.userinputservice:WaitForChild("GetMouseLocation")),
	["UserInputService GetNavigationGamepads"] = require(Shared.nodes.userinputservice:WaitForChild("GetNavigationGamepads")),
	["UserInputService GetStringForKeyCode"] = require(Shared.nodes.userinputservice:WaitForChild("GetStringForKeyCode")),
	["UserInputService GetSupportedGamepadKeyCodes"] = require(Shared.nodes.userinputservice:WaitForChild("GetSupportedGamepadKeyCodes")),
	["UserInputService GetUserCFrame"] = require(Shared.nodes.userinputservice:WaitForChild("GetUserCFrame")),
	["UserInputService IsGamepadButtonDown"] = require(Shared.nodes.userinputservice:WaitForChild("IsGamepadButtonDown")),
	["UserInputService IsKeyDown"] = require(Shared.nodes.userinputservice:WaitForChild("IsKeyDown")),
	["UserInputService IsMouseButtonPressed"] = require(Shared.nodes.userinputservice:WaitForChild("IsMouseButtonPressed")),
	["UserInputService IsNavigationGamepad"] = require(Shared.nodes.userinputservice:WaitForChild("IsNavigationGamepad")),
	["UserInputService RecenterUserHeadCFrame"] = require(Shared.nodes.userinputservice:WaitForChild("RecenterUserHeadCFrame")),
	["UserInputService SetNavigationGamepad"] = require(Shared.nodes.userinputservice:WaitForChild("SetNavigationGamepad")),
	["Instance to UserInputService"] = require(Shared.nodes.userinputservice:WaitForChild("InstanceToUserInputService")),
	["UserInputService DeviceAccelerationChanged"] = require(Shared.nodes.userinputservice:WaitForChild("DeviceAccelerationChanged")),
	["UserInputService DeviceGravityChanged"] = require(Shared.nodes.userinputservice:WaitForChild("DeviceGravityChanged")),
	["UserInputService DeviceRotationChanged"] = require(Shared.nodes.userinputservice:WaitForChild("DeviceRotationChanged")),
	["UserInputService GamepadConnected"] = require(Shared.nodes.userinputservice:WaitForChild("GamepadConnected")),
	["UserInputService GamepadDisconnected"] = require(Shared.nodes.userinputservice:WaitForChild("GamepadDisconnected")),
	["UserInputService InputBegan"] = require(Shared.nodes.userinputservice:WaitForChild("InputBegan")),
	["UserInputService InputChanged"] = require(Shared.nodes.userinputservice:WaitForChild("InputChanged")),
	["UserInputService InputEnded"] = require(Shared.nodes.userinputservice:WaitForChild("InputEnded")),
	["UserInputService JumpRequest"] = require(Shared.nodes.userinputservice:WaitForChild("JumpRequest")),
	["UserInputService LastInputTypeChanged"] = require(Shared.nodes.userinputservice:WaitForChild("LastInputTypeChanged")),
	["UserInputService PointerAction"] = require(Shared.nodes.userinputservice:WaitForChild("PointerAction")),
	["UserInputService TextBoxFocused"] = require(Shared.nodes.userinputservice:WaitForChild("TextBoxFocused")),
	["UserInputService TextBoxFocusReleased"] = require(Shared.nodes.userinputservice:WaitForChild("TextBoxFocusReleased")),
	["UserInputService TouchDrag"] = require(Shared.nodes.userinputservice:WaitForChild("TouchDrag")),
	["UserInputService TouchEnded"] = require(Shared.nodes.userinputservice:WaitForChild("TouchEnded")),
	["UserInputService TouchLongPress"] = require(Shared.nodes.userinputservice:WaitForChild("TouchLongPress")),
	["UserInputService TouchMoved"] = require(Shared.nodes.userinputservice:WaitForChild("TouchMoved")),
	["UserInputService TouchPan"] = require(Shared.nodes.userinputservice:WaitForChild("TouchPan")),
	["UserInputService TouchPinch"] = require(Shared.nodes.userinputservice:WaitForChild("TouchPinch")),
	["UserInputService TouchRotate"] = require(Shared.nodes.userinputservice:WaitForChild("TouchRotate")),
	["UserInputService TouchStarted"] = require(Shared.nodes.userinputservice:WaitForChild("TouchStarted")),
	["UserInputService TouchSwipe"] = require(Shared.nodes.userinputservice:WaitForChild("TouchSwipe")),
	["UserInputService TouchTap"] = require(Shared.nodes.userinputservice:WaitForChild("TouchTap")),
	["UserInputService TouchTapInWorld"] = require(Shared.nodes.userinputservice:WaitForChild("TouchTapInWorld")),
	["UserInputService UserCFrameChanged"] = require(Shared.nodes.userinputservice:WaitForChild("UserCFrameChanged")),
	["UserInputService WindowFocused"] = require(Shared.nodes.userinputservice:WaitForChild("WindowFocused")),
	["UserInputService WindowFocusReleased"] = require(Shared.nodes.userinputservice:WaitForChild("WindowFocusReleased")),

	-- RunService nodes
	["RunService BindToRenderStep"] = require(Shared.nodes.runservice:WaitForChild("BindToRenderStep")),
	["RunService BindToSimulation"] = require(Shared.nodes.runservice:WaitForChild("BindToSimulation")),
	["RunService GetPredictionStatus"] = require(Shared.nodes.runservice:WaitForChild("GetPredictionStatus")),
	["RunService IsClient"] = require(Shared.nodes.runservice:WaitForChild("IsClient")),
	["RunService IsEdit"] = require(Shared.nodes.runservice:WaitForChild("IsEdit")),
	["RunService IsRunMode"] = require(Shared.nodes.runservice:WaitForChild("IsRunMode")),
	["RunService IsRunning"] = require(Shared.nodes.runservice:WaitForChild("IsRunning")),
	["RunService IsServer"] = require(Shared.nodes.runservice:WaitForChild("IsServer")),
	["RunService IsStudio"] = require(Shared.nodes.runservice:WaitForChild("IsStudio")),
	["RunService Pause"] = require(Shared.nodes.runservice:WaitForChild("Pause")),
	["RunService Reset"] = require(Shared.nodes.runservice:WaitForChild("Reset")),
	["RunService Run"] = require(Shared.nodes.runservice:WaitForChild("Run")),
	["RunService SetPredictionMode"] = require(Shared.nodes.runservice:WaitForChild("SetPredictionMode")),
	["RunService Stop"] = require(Shared.nodes.runservice:WaitForChild("Stop")),
	["RunService UnbindFromRenderStep"] = require(Shared.nodes.runservice:WaitForChild("UnbindFromRenderStep")),
	["Instance to RunService"] = require(Shared.nodes.runservice:WaitForChild("InstanceToRunService")),
	["RunService Heartbeat"] = require(Shared.nodes.runservice:WaitForChild("Heartbeat")),
	["RunService Misprediction"] = require(Shared.nodes.runservice:WaitForChild("Misprediction")),
	["RunService PostSimulation"] = require(Shared.nodes.runservice:WaitForChild("PostSimulation")),
	["RunService PreAnimation"] = require(Shared.nodes.runservice:WaitForChild("PreAnimation")),
	["RunService PreRender"] = require(Shared.nodes.runservice:WaitForChild("PreRender")),
	["RunService PreSimulation"] = require(Shared.nodes.runservice:WaitForChild("PreSimulation")),
	["RunService RenderStepped"] = require(Shared.nodes.runservice:WaitForChild("RenderStepped")),
	["RunService Rollback"] = require(Shared.nodes.runservice:WaitForChild("Rollback")),
	["RunService Stepped"] = require(Shared.nodes.runservice:WaitForChild("Stepped")),

	-- HttpService nodes
	["HttpService CreateWebStreamClient"] = require(Shared.nodes.httpservice:WaitForChild("CreateWebStreamClient")),
	["HttpService GenerateGUID"] = require(Shared.nodes.httpservice:WaitForChild("GenerateGUID")),
	["HttpService GetAsync"] = require(Shared.nodes.httpservice:WaitForChild("GetAsync")),
	["HttpService GetSecret"] = require(Shared.nodes.httpservice:WaitForChild("GetSecret")),
	["HttpService JSONDecode"] = require(Shared.nodes.httpservice:WaitForChild("JSONDecode")),
	["HttpService JSONEncode"] = require(Shared.nodes.httpservice:WaitForChild("JSONEncode")),
	["HttpService PostAsync"] = require(Shared.nodes.httpservice:WaitForChild("PostAsync")),
	["HttpService RequestAsync"] = require(Shared.nodes.httpservice:WaitForChild("RequestAsync")),
	["HttpService UrlEncode"] = require(Shared.nodes.httpservice:WaitForChild("UrlEncode")),
	["Instance to HttpService"] = require(Shared.nodes.conversions:WaitForChild("InstanceToHttpService")),

	-- Lighting nodes
	["Lighting GetMinutesAfterMidnight"] = require(Shared.nodes.lighting:WaitForChild("GetMinutesAfterMidnight")),
	["Lighting GetSunDirection"] = require(Shared.nodes.lighting:WaitForChild("GetSunDirection")),
	["Lighting GetMoonDirection"] = require(Shared.nodes.lighting:WaitForChild("GetMoonDirection")),
	["Lighting SetMinutesAfterMidnight"] = require(Shared.nodes.lighting:WaitForChild("SetMinutesAfterMidnight")),
	["Lighting LightingChanged"] = require(Shared.nodes.lighting:WaitForChild("LightingChanged")),
	["Instance to Lighting"] = require(Shared.nodes.conversions:WaitForChild("InstanceToLighting")),
}

local networking = Shared.nodes:WaitForChild("networking")
Nodes["FireServer"] = require(networking:WaitForChild("FireServer"))
Nodes["FireClient"] = require(networking:WaitForChild("FireClient"))
Nodes["FireAllClients"] = require(networking:WaitForChild("FireAllClients"))
Nodes["OnServerEvent"] = require(networking:WaitForChild("OnServerEvent"))
Nodes["OnClientEvent"] = require(networking:WaitForChild("OnClientEvent"))
Nodes["InvokeServer"] = require(networking:WaitForChild("InvokeServer"))
Nodes["InvokeClient"] = require(networking:WaitForChild("InvokeClient"))
Nodes["OnServerInvoke"] = require(networking:WaitForChild("OnServerInvoke"))
Nodes["OnClientInvoke"] = require(networking:WaitForChild("OnClientInvoke"))
Nodes["Remote Return"] = require(networking:WaitForChild("RemoteReturn"))

-- Special nodes handled dynamically
Nodes["Function Entry"] = FunctionEntry
Nodes["Function Return"] = FunctionReturn
Nodes["Function Call"] = FunctionCall

-- Toolbar button (toggle widget only)
local toolbar      = plugin:CreateToolbar("Blueprint Roblox Editor")
local pluginButton = toolbar:CreateButton("BRE", "Open the Blueprint Editor", "rbxassetid://89458565936494")
pluginButton.ClickableWhenViewportHidden = true

-- Docking widget
local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Float, true, false, 800, 500, 400, 300)
local widget     = plugin:CreateDockWidgetPluginGuiAsync("BlueprintEditorWidget", widgetInfo)
widget.Title     = "Blueprint Editor"
widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Sync toolbar button active state with widget visibility
widget:GetPropertyChangedSignal("Enabled"):Connect(function()
	pluginButton:SetActive(widget.Enabled)
end)
pluginButton:SetActive(widget.Enabled)

pluginButton.Click:Connect(function()
	widget.Enabled = not widget.Enabled
end)

-- Build UI (order matters for Sibling ZIndex: last created = on top)
local canvas  = Canvas.new(widget)   -- bottom layer
local sidebar = Sidebar.new(widget)  -- above canvas
local topBar  = TopBar.new(widget)   -- top layer

-- Offset canvas to the right of the sidebar
canvas:SetLeftOffset(sidebar:GetWidth())

local newProjectBtn  = topBar:AddButton("NewProjectBtn",  "+ New Project")
local openProjectBtn = topBar:AddButton("OpenProjectBtn", "Open Project")
local saveProjectBtn = topBar:AddButton("SaveProjectBtn", "Save Project")
local exportBtn      = topBar:AddButton("ExportBtn",      "Export Current")
local exportAllBtn   = topBar:AddButton("ExportAllBtn",   "Export All")

-- Initialise services
local fm           = FileManager.new(plugin)

-- Project state
local projectActive      = false
local currentProjectName = nil
local _currentProjectData = nil
local currentGraph       = Graph.new()
local visualNodes        = {}
local visualWires        = {} -- stores drawn wire frames with metadata
local hoveredNode        = nil
local hoveredWire        = nil
local currentScriptHandle = nil

local UserInputService = game:GetService("UserInputService")

local function handleKeyDown(keyCode)
	if UserInputService:GetFocusedTextBox() then return end
	
	if (keyCode == Enum.KeyCode.Delete or keyCode == Enum.KeyCode.Backspace) then
		if hoveredNode then
			--print("[Editor] Deleting node: " .. hoveredNode.nodeData.Name)
			
			-- 1. Remove from Graph
			currentGraph:remove_node(hoveredNode.nodeData)
			
			-- 2. Remove connected visual wires
			for i = #visualWires, 1, -1 do
				local wire = visualWires[i]
				if wire.fromNode == hoveredNode.nodeData or wire.toNode == hoveredNode.nodeData then
					-- Show input field again if it was a target pin
					if wire.toNode ~= hoveredNode.nodeData and wire.toPinId then
						for _, vNode in ipairs(visualNodes) do
							if vNode.nodeData == wire.toNode then
								vNode:UpdatePinState(wire.toPinId, false)
								break
							end
						end
					end
					
					wire.line:Destroy()
					if wire.hbConn then wire.hbConn:Disconnect() end
					table.remove(visualWires, i)
				end
			end
			
			-- 3. Remove from visualNodes list
			for i, vNode in ipairs(visualNodes) do
				if vNode == hoveredNode then
					table.remove(visualNodes, i)
					break
				end
			end
			
			-- 4. Destroy UI
			hoveredNode:Destroy()
			hoveredNode = nil
		elseif hoveredWire then
			-- Deleting a connection
			-- 1. Remove from Graph
			currentGraph:disconnect(hoveredWire.fromNode, hoveredWire.toNode, hoveredWire.fromPinName, hoveredWire.toPinName, hoveredWire.isExec)
			
			-- 2. Show input field again if it was a data target pin
			if not hoveredWire.isExec and hoveredWire.toPinId then
				for _, vNode in ipairs(visualNodes) do
					if vNode.nodeData == hoveredWire.toNode then
						vNode:UpdatePinState(hoveredWire.toPinId, false)
						break
					end
				end
			end
			
			-- 3. Destroy UI
			hoveredWire.line:Destroy()
			if hoveredWire.hbConn then hoveredWire.hbConn:Disconnect() end
			
			-- 4. Remove from visualWires
			for i, w in ipairs(visualWires) do
				if w == hoveredWire then
					table.remove(visualWires, i)
					break
				end
			end
			
			hoveredWire = nil
		else
			--print("[Editor] Delete pressed but nothing hovered")
		end
	end
end

-- ── Wires Global State ────────────────────────────────────────────────────────
local wiresFrame = Instance.new("Frame")
wiresFrame.Name = "Wires"
wiresFrame.Size = UDim2.new(1, 0, 1, 0)
wiresFrame.BackgroundTransparency = 1
wiresFrame.ZIndex = 5
wiresFrame.Parent = canvas:GetNodeContainer()

local hoveredPin = nil
local wireDragging = false
local wireStartInfo = nil
local tempWireFrame = nil
local dragMousePos = Vector2.new()

local function drawWireLine(parent, p1, p2, color)
	local line = Instance.new("Frame")
	local distance = (p2 - p1).Magnitude
	local center = (p1 + p2) / 2
	local angle = math.atan2(p2.Y - p1.Y, p2.X - p1.X)
	
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Position = UDim2.fromOffset(center.X, center.Y)
	line.Size = UDim2.fromOffset(distance, 3)
	line.Rotation = math.deg(angle)
	line.BackgroundColor3 = color
	line.BorderSizePixel = 0
	line.ZIndex = 5
	line.Parent = parent

	-- Invisible hitbox for easier selection
	local hitbox = Instance.new("TextButton")
	hitbox.Name = "WireHitbox"
	hitbox.Size = UDim2.new(1, 0, 1, 10)
	hitbox.Position = UDim2.new(0, 0, 0.5, -5)
	hitbox.BackgroundTransparency = 1
	hitbox.Text = ""
	hitbox.ZIndex = 6
	hitbox.Parent = line

	return line
end

local function registerWireHover(wireObj)
	local line = wireObj.line
	local hitbox = line:WaitForChild("WireHitbox")
	local baseColor = line.BackgroundColor3
	local highlightColor = Color3.fromRGB(255, 210, 80)
	
	hitbox.MouseEnter:Connect(function()
		hoveredWire = wireObj
		line.BackgroundColor3 = highlightColor
		line.Size = UDim2.new(line.Size.X.Scale, line.Size.X.Offset, 0, 5)
	end)
	
	hitbox.MouseLeave:Connect(function()
		if hoveredWire == wireObj then
			hoveredWire = nil
			line.BackgroundColor3 = baseColor
			line.Size = UDim2.new(line.Size.X.Scale, line.Size.X.Offset, 0, 3)
		end
	end)
end

local function clearCanvas()
	for _, vNode in ipairs(visualNodes) do
		vNode:Destroy()
	end
	visualNodes = {}
	
	for _, wire in ipairs(visualWires) do
		wire.line:Destroy()
		if wire.hbConn then wire.hbConn:Disconnect() end
	end
	visualWires = {}
	
	hoveredNode = nil
end

local function renderWiresOnly(graph)
	if not projectActive then return end

	-- 0. Reset connection states for all visual nodes before re-calculating
	for _, vNode in ipairs(visualNodes) do
		for pinId, _ in pairs(vNode.connections) do
			vNode:UpdatePinState(pinId, false)
		end
	end

	-- 1. Clear current visual wires
	for _, edge in ipairs(graph.exec_edges) do
		local outNode = edge.FromNode
		local inNode = edge.ToNode
		
		-- Find visual pins
		local vOut, vIn
		for _, vNode in ipairs(visualNodes) do
			if vNode.nodeData == outNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if pInfo.isOutput and pInfo.pinData.Name == edge.FromPort then
						vOut = pInfo.pinGui
						break
					end
				end
			elseif vNode.nodeData == inNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if not pInfo.isOutput and pInfo.pinData.Name == edge.ToPort then
						vIn = pInfo.pinGui
						break
					end
				end
			end
		end
		
		if vOut and vIn then
			local function updatePermanentWire()
				local zoom = canvas:GetZoom()
				local cPos = canvas:GetNodeContainer().AbsolutePosition
				local p1 = (vOut.AbsolutePosition + (vOut.AbsoluteSize / 2) - cPos) / zoom
				local p2 = (vIn.AbsolutePosition + (vIn.AbsoluteSize / 2) - cPos) / zoom
				return p1, p2
			end
			local p1, p2 = updatePermanentWire()
			local line = drawWireLine(wiresFrame, p1, p2, Color3.fromRGB(240, 240, 240))
			
			local fromPinId, toPinId
			for _, out in ipairs(outNode:getOutputs()) do
				if out.Name == edge.FromPort then fromPinId = out.Id; break end
			end
			for _, inp in ipairs(inNode:getInputs()) do
				if inp.Name == edge.ToPort then toPinId = inp.Id; break end
			end

			local wireObj = { 
				line = line, 
				fromNode = outNode, 
				toNode = inNode, 
				fromPinName = edge.FromPort,
				toPinName = edge.ToPort,
				fromPinId = fromPinId,
				toPinId = toPinId,
				isExec = true,
				hbConn = nil 
			}
			for _, inp in ipairs(inNode:getInputs()) do
				if inp.Name == edge.ToPort then
					wireObj.toPinId = inp.Id
					break
				end
			end

			wireObj.hbConn = RunService.Heartbeat:Connect(function()
				local np1, np2 = updatePermanentWire()
				local distance = (np2 - np1).Magnitude
				local center = (np1 + np2) / 2
				local angle = math.atan2(np2.Y - np1.Y, np2.X - np1.X)
				line.Position = UDim2.fromOffset(center.X, center.Y)
				local h = (hoveredWire == wireObj) and 5 or 3
				line.Size = UDim2.fromOffset(distance, h)
				line.Rotation = math.deg(angle)
			end)
			table.insert(visualWires, wireObj)
			registerWireHover(wireObj)
			-- Update visual states for both nodes
			for _, vNode in ipairs(visualNodes) do
				if vNode.nodeData == outNode and fromPinId then
					vNode:UpdatePinState(fromPinId, true)
				end
				if vNode.nodeData == inNode and toPinId then
					vNode:UpdatePinState(toPinId, true)
				end
			end

		end
	end
	
	-- Render Data edges
	for _, edge in ipairs(graph.data_edges) do
		local outNode = edge.FromNode
		local inNode = edge.ToNode
		
		local vOut, vIn
		for _, vNode in ipairs(visualNodes) do
			if vNode.nodeData == outNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if pInfo.isOutput and pInfo.pinData.Name == edge.FromPort then
						vOut = pInfo.pinGui
						break
					end
				end
			elseif vNode.nodeData == inNode then
				for _, pInfo in ipairs(vNode:GetPins()) do
					if not pInfo.isOutput and pInfo.pinData.Name == edge.ToPort then
						vIn = pInfo.pinGui
						break
					end
				end
			end
		end
		
		if vOut and vIn then
			local function updatePermanentWire()
				local zoom = canvas:GetZoom()
				local cPos = canvas:GetNodeContainer().AbsolutePosition
				local p1 = (vOut.AbsolutePosition + (vOut.AbsoluteSize / 2) - cPos) / zoom
				local p2 = (vIn.AbsolutePosition + (vIn.AbsoluteSize / 2) - cPos) / zoom
				return p1, p2
			end
			local p1, p2 = updatePermanentWire()
			local line = drawWireLine(wiresFrame, p1, p2, Color3.fromRGB(110, 180, 240))
			
			-- Find pin IDs to update their states
			local fromPinId, toPinId
			for _, out in ipairs(outNode:getOutputs()) do
				if out.Name == edge.FromPort then
					fromPinId = out.Id
					break
				end
			end
			for _, inp in ipairs(inNode:getInputs()) do
				if inp.Name == edge.ToPort then
					toPinId = inp.Id
					break
				end
			end

			local wireObj = { 
				line = line, 
				fromNode = outNode, 
				toNode = inNode, 
				fromPinName = edge.FromPort,
				toPinName = edge.ToPort,
				fromPinId = fromPinId,
				toPinId = toPinId,
				isExec = false,
				hbConn = nil 
			}

			wireObj.hbConn = RunService.Heartbeat:Connect(function()
				local np1, np2 = updatePermanentWire()
				local distance = (np2 - np1).Magnitude
				local center = (np1 + np2) / 2
				local angle = math.atan2(np2.Y - np1.Y, np2.X - np1.X)
				line.Position = UDim2.fromOffset(center.X, center.Y)
				local h = (hoveredWire == wireObj) and 5 or 3
				line.Size = UDim2.fromOffset(distance, h)
				line.Rotation = math.deg(angle)
			end)
			table.insert(visualWires, wireObj)
			registerWireHover(wireObj)
			
			-- Update visual states for both nodes
			for _, vNode in ipairs(visualNodes) do
				if vNode.nodeData == outNode and fromPinId then
					vNode:UpdatePinState(fromPinId, true)
				end
				if vNode.nodeData == inNode and toPinId then
					vNode:UpdatePinState(toPinId, true)
				end
			end
		end
	end
end

local function hookUpNodeEvents(visualNode, nodeInstance)
	visualNode.OnSelect.Event:Connect(function()
		for _, v in ipairs(visualNodes) do
			if v ~= visualNode then
				v:Deselect()
			end
		end
	end)
	
	visualNode.OnHover.Event:Connect(function()
		--print("[Editor] Hovering node: " .. nodeInstance.Name)
		hoveredNode = visualNode
	end)
	
	visualNode.OnHoverEnd.Event:Connect(function()
		if hoveredNode == visualNode then
			--print("[Editor] Stopped hovering node: " .. nodeInstance.Name)
			hoveredNode = nil
		end
	end)
	
	visualNode.OnKeyDown.Event:Connect(function(keyCode)
		handleKeyDown(keyCode)
	end)

	visualNode.OnRefresh.Event:Connect(function()
		if nodeInstance.Refresh then
			local context = { projectScripts = sidebar:GetScripts() or {} }
			nodeInstance:Refresh(context)
		end
	end)

	nodeInstance.OnPinsChanged.Event:Connect(function()
		-- Redraw the node UI
		local oldPos = visualNode.frame.Position
		
		-- 1. Remove current visual node
		visualNode:Destroy()
		for i, v in ipairs(visualNodes) do
			if v == visualNode then
				table.remove(visualNodes, i)
				break
			end
		end
		
		-- 2. Recreate visual node
		local newNode = NodeComponent.new(canvas:GetNodeContainer(), nodeInstance)
		newNode.frame.Position = oldPos
		table.insert(visualNodes, newNode)
		hookUpNodeEvents(newNode, nodeInstance)
		
		-- Update hoveredNode if it was the one being changed
		if hoveredNode == visualNode then
			hoveredNode = newNode
		end

		-- 3. Update wire references
		for _, wire in ipairs(visualWires) do
			if wire.fromNode == nodeInstance or wire.toNode == nodeInstance then
				-- We need to re-find the pin GuiObjects
				local vOut, vIn = nil, nil
				
				-- Find fromNode visual
				local vFromNode = nil
				for _, vn in ipairs(visualNodes) do
					if vn.nodeData == wire.fromNode then vFromNode = vn; break end
				end
				if vFromNode then
					for _, pInfo in ipairs(vFromNode:GetPins()) do
						if pInfo.isOutput and pInfo.pinData.Name == wire.fromPinName then
							vOut = pInfo.pinGui
							break
						end
					end
				end
				
				-- Find toNode visual
				local vToNode = nil
				for _, vn in ipairs(visualNodes) do
					if vn.nodeData == wire.toNode then vToNode = vn; break end
				end
				if vToNode then
					for _, pInfo in ipairs(vToNode:GetPins()) do
						if not pInfo.isOutput and pInfo.pinData.Name == wire.toPinName then
							vIn = pInfo.pinGui
							break
						end
					end
				end
				
				-- We just need to trigger a redraw for this wire's node
				if vOut or vIn then
					-- Redraw triggered below
				end
			end
		end
		
		-- Re-apply wire connections for this node
		-- Clear old wires for this node
		for i = #visualWires, 1, -1 do
			local wire = visualWires[i]
			if wire.fromNode == nodeInstance or wire.toNode == nodeInstance then
				wire.line:Destroy()
				if wire.hbConn then wire.hbConn:Disconnect() end
				table.remove(visualWires, i)
			end
		end
		
		-- Redraw wires for this node
		-- We can iterate over currentGraph edges
		for _, edge in ipairs(currentGraph.exec_edges) do
			if edge.FromNode == nodeInstance or edge.ToNode == nodeInstance then
				-- logic to redraw a single edge (extract it to a function?)
			end
		end
		-- This is getting complex. Let's just redraw ALL wires for now.
		for i = #visualWires, 1, -1 do
			local wire = visualWires[i]
			wire.line:Destroy()
			if wire.hbConn then wire.hbConn:Disconnect() end
			table.remove(visualWires, i)
		end
		
		-- Re-render graph (but skip nodes, only wires)
		task.wait()
		renderWiresOnly(currentGraph)
	end)

	visualNode.OnPinDragStart.Event:Connect(function(nodeId, pinData, isOutput, pinGui, inputPos)
		if tempWireFrame then
			tempWireFrame:Destroy()
		end
		
		local nodeInstance = currentGraph.nodes[nodeId]
		if not nodeInstance then return end

		wireDragging = true
		dragMousePos = Vector2.new(inputPos.X, inputPos.Y)
		wireStartInfo = { nodeData = nodeInstance, pinData = pinData, isOutput = isOutput, pinGui = pinGui }
		
		tempWireFrame = Instance.new("Frame")
		tempWireFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		tempWireFrame.BackgroundColor3 = pinData.IsExec and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(110, 180, 240)
		tempWireFrame.BorderSizePixel = 0
		tempWireFrame.ZIndex = 10
		tempWireFrame.Parent = wiresFrame
	end)

	visualNode.OnPinHover.Event:Connect(function(nodeId, pinData, isOutput, pinGui)
		local nodeInstance = currentGraph.nodes[nodeId]
		if not nodeInstance then return end
		hoveredPin = { nodeData = nodeInstance, pinData = pinData, isOutput = isOutput, pinGui = pinGui }
	end)
	
	visualNode.OnPinHoverEnd.Event:Connect(function()
		hoveredPin = nil
	end)
	
	visualNode.OnPinDragEnd.Event:Connect(function()
		if wireDragging then
			wireDragging = false
			if tempWireFrame then
				tempWireFrame:Destroy()
				tempWireFrame = nil
			end
			
			if hoveredPin and wireStartInfo then
				--print("[Wire] Dropped on pin: " .. hoveredPin.pinData.Name .. " of node: " .. hoveredPin.nodeData.Name)
				-- Check if valid: one output, one input
				if wireStartInfo.isOutput ~= hoveredPin.isOutput then
					local isExec1 = wireStartInfo.pinData.IsExec
					local isExec2 = hoveredPin.pinData.IsExec
					if isExec1 == isExec2 then
						--print(string.format("[Wire] VALID CONNECTION! %s -> %s", wireStartInfo.nodeData.Name, hoveredPin.nodeData.Name))
						-- valid connection
						local outInfo = wireStartInfo.isOutput and wireStartInfo or hoveredPin
						local inInfo = not wireStartInfo.isOutput and wireStartInfo or hoveredPin
						
						if isExec1 then
							currentGraph:connect_exec(outInfo.nodeData, inInfo.nodeData, outInfo.pinData.Name, inInfo.pinData.Name)
						else
							currentGraph:connect_data(outInfo.nodeData, inInfo.nodeData, outInfo.pinData.Name, inInfo.pinData.Name)
						end
						
						-- Redraw all wires to ensure everything is synchronized
						task.wait()
						renderWiresOnly(currentGraph)
					end
				end
			end
		end
	end)
end

local function spawnNode(nodeId, screenPosition, configFunc)
	local nodeInstance
	if nodeId == "Function Entry" then
		nodeInstance = FunctionEntry.new(currentScriptHandle.data.inputs)
	elseif nodeId:sub(1, 12) == "MethodEntry:" then
		local mName = nodeId:sub(13)
		local mData
		for _, m in ipairs(currentScriptHandle.data.methods or {}) do
			if m.name == mName then mData = m; break end
		end
		nodeInstance = FunctionEntry.new(mData and mData.inputs or {}, mName)
	elseif nodeId == "Function Return" then
		nodeInstance = FunctionReturn.new(currentScriptHandle.data.outputs)
	elseif nodeId:sub(1, 13) == "MethodReturn:" then
		local mName = nodeId:sub(14)
		local mData
		for _, m in ipairs(currentScriptHandle.data.methods or {}) do
			if m.name == mName then mData = m; break end
		end
		nodeInstance = FunctionReturn.new(mData and mData.outputs or {}, mName)
	elseif nodeId:sub(1, 4) == "Call" then
		-- Extract script name from "Call MyFunction"
		local fnName = nodeId:sub(6)
		local allScripts = sidebar:GetScripts()
		local targetScript
		for _, s in ipairs(allScripts) do
			if s.name == fnName then targetScript = s; break end
		end
		if targetScript then
			nodeInstance = FunctionCall.new(fnName, targetScript.inputs, targetScript.outputs)
		else
			-- Fallback if not found (shouldn't happen with correct menu)
			nodeInstance = FunctionCall.new(fnName)
		end
	else
		local nodeClass = Nodes[nodeId]
		if not nodeClass then return end
		nodeInstance = nodeClass.new()
	end
	
	nodeInstance.Class = nodeId
	
	-- Place it under the mouse cursor in the canvas
	local canvasPos = canvas:GetInstance().AbsolutePosition
	local panOffset = canvas:GetPanOffset()
	local zoom      = canvas:GetZoom()
	
	local relativeX = (screenPosition.X - canvasPos.X) / zoom - panOffset.X
	local relativeY = (screenPosition.Y - canvasPos.Y) / zoom - panOffset.Y
	
	nodeInstance:editPosition(Vector2.new(relativeX, relativeY))
	
	if configFunc then configFunc(nodeInstance) end
	
	currentGraph:add_node(nodeInstance)
	
	local visualNode = NodeComponent.new(canvas:GetNodeContainer(), nodeInstance)
	table.insert(visualNodes, visualNode)
	hookUpNodeEvents(visualNode, nodeInstance)
	
	return nodeInstance, visualNode
end
local function onVariableAction(varName, actionType)
	if not projectActive then return end
	-- Spawn near center of screen
	local center = canvas:GetInstance().AbsolutePosition + (canvas:GetInstance().AbsoluteSize / 2)
	spawnNode(actionType .. " Variable", center, function(node)
		local nameInput = node:getInput("name")
		if nameInput then nameInput.Value = varName end
	end)
end

local function addVariableToSidebar(varName)
	sidebar:AddVariable(varName, 
		function() onVariableAction(varName, "Get") end, 
		function() onVariableAction(varName, "Set") end
	)
end


local function renderGraph(graph)
	for _, node in pairs(graph.nodes) do
		local visualNode = NodeComponent.new(canvas:GetNodeContainer(), node)
		table.insert(visualNodes, visualNode)
		hookUpNodeEvents(visualNode, node)
	end
	
	renderWiresOnly(graph)
end


local function switchScript(handle)
	if not projectActive then return end
	
	-- 1. Save current state to the old handle
	if currentScriptHandle then
		currentScriptHandle.data.graph = currentGraph:serialize()
		currentScriptHandle.data.variables = sidebar:GetVariables()
		currentScriptHandle:Deselect()
	end
	
	-- 2. Clear canvas and variable list
	clearCanvas()
	sidebar:ClearVariables()
	
	-- 3. Load new graph
	currentScriptHandle = handle
	currentScriptHandle:Select()
	
	if handle.data.graph then
		local context = { script = handle.data, projectScripts = sidebar:GetScripts() }
		currentGraph = Graph.from_data(handle.data.graph, Nodes, context)
	else
		currentGraph = Graph.new()
	end
	
	-- 4. Load script-local variables
	for _, vName in ipairs(handle.data.variables or {}) do
		addVariableToSidebar(vName)
	end
	
	-- 5. Render
	renderGraph(currentGraph)
end


-- Ready


-- ── Sidebar: Scripts ──────────────────────────────────────────────────────────
local function onEditScript(handle)
	ScriptModal.prompt(widget, handle.data, function(updatedData)
		-- Update the data
		handle.data = updatedData
		-- Update UI
		handle.nameLabel.Text = updatedData.name
		handle.typeBtn.Text = updatedData.type == "Function" and "FUN" or (updatedData.type == "Module" and "MOD" or "DEF")
	end)
end

-- ── Start a project (shared setup for new / open) ─────────────────────────────
local function activateProject(data, name)
	projectActive      = true
	currentProjectName = name or data.name or "Untitled"
	_currentProjectData = data

	clearCanvas()
	sidebar:Clear()
	currentScriptHandle = nil
	
	-- Populate sidebar with scripts
	local firstHandle = nil
	for _, sData in ipairs(data.scripts or {}) do
		local handle = sidebar:AddScript(sData, onEditScript)
		if not firstHandle then firstHandle = handle end
	end
	
	-- Populate sidebar with variables (deprecated global variables moved to the first script for compatibility)
	local globalVars = data.variables or {}
	if #globalVars > 0 and firstHandle then
		firstHandle.data.variables = firstHandle.data.variables or {}
		for _, vName in ipairs(globalVars) do
			if not table.find(firstHandle.data.variables, vName) then
				table.insert(firstHandle.data.variables, vName)
			end
		end
	end

	canvas:ShowGrid()
	canvas:HidePlaceholder()

	widget.Title = "Blueprint Editor  -  " .. currentProjectName
	
	-- Switch to first script
	if firstHandle then
		switchScript(firstHandle)
	else
		currentGraph = Graph.new()
	end
end

-- ── Collect current project data ──────────────────────────────────────────────
local function gatherProjectData()
	-- Save active graph and variables
	if currentScriptHandle then
		currentScriptHandle.data.graph = currentGraph:serialize()
		currentScriptHandle.data.variables = sidebar:GetVariables()
	end
	
	return {
		name        = currentProjectName,
		variables   = {}, -- No more global variables
		scripts     = sidebar:GetScripts(),
	}
end

-- ── New Project ────────────────────────────────────────────────────────────────
newProjectBtn:OnClick(function()
	local defaultData = { 
		name = "Untitled", 
		variables = {}, 
		scripts = { { name = "Main", type = "Default", graph = nil } } 
	}
	activateProject(defaultData, nil)
end)

-- ── Open Project ───────────────────────────────────────────────────────────────
openProjectBtn:OnClick(function()
	local project = fm:OpenJSON({"json"})
	if project == nil then return end

	activateProject(project.data, project.name)
end)

-- ── Save Project ───────────────────────────────────────────────────────────────
saveProjectBtn:OnClick(function()
	if not projectActive then return end

	local data = gatherProjectData()

	-- Export to StringValue for manual copy
	fm:ExportToStringValue(data)

	canvas:SetPlaceholder(
		"Project saved!\n\n"
		.. "JSON exported to workspace.__BlueprintExport.\n"
		.. "Select it in Explorer and copy the Value."
	)
	task.delay(3, function()
		if projectActive then canvas:HidePlaceholder() end
	end)
end)

-- ── Export Logic ──────────────────────────────────────────────────────────────

local function compileScriptData(sData, variables, allScripts, alreadyInlined)
	alreadyInlined = alreadyInlined or {}
	if not sData.graph then return "-- No graph data for " .. sData.name .. "\n" end
	if alreadyInlined[sData.name] then return "" end -- Already inlined
	
	-- 1. Restore the graph to find dependencies
	local context = { script = sData, projectScripts = allScripts }
	local graph = Graph.from_data(sData.graph, Nodes, context)
	
	-- 2. Resolve dependencies (functions called by this script)
	local dependenciesCode = ""
	for _, node in pairs(graph.nodes) do
		if node.Name == "Function Call" then
			local fnNameInput = node:getInput("__functionName")
			local fnName = fnNameInput and fnNameInput.Value or ""
			
			if fnName ~= "" and not alreadyInlined[fnName] then
				-- Find the script data for this function
				local depScript = nil
				for _, s in ipairs(allScripts) do
					if s.name == fnName then depScript = s; break end
				end
				
				if depScript then
					dependenciesCode ..= compileScriptData(depScript, nil, allScripts, alreadyInlined) .. "\n"
				end
			end
		end
	end
	
	-- 3. Mark this one as processed AFTER dependencies so they come first in the code
	alreadyInlined[sData.name] = true
	
	-- 4. Generate Luau for this specific graph
	local code = ""
	local ok, err = pcall(function()
		code = graph:toLuau(variables)
	end)
	
	if not ok then
		warn("[Compiler] Failed to compile " .. sData.name .. ": " .. tostring(err))
		return "-- Compilation Error: " .. tostring(err) .. "\n"
	end
	
	-- 5. Wrap based on type
	if sData.type == "Function" then
		local params = {}
		for _, inp in ipairs(sData.inputs or {}) do
			if inp.name and inp.name ~= "" then
				table.insert(params, inp.name)
			end
		end
		local paramStr = table.concat(params, ", ")
		return dependenciesCode .. "local function " .. sData.name .. "(" .. paramStr .. ")\n" .. Block.indentCode(code) .. "end\n"
	elseif sData.type == "Module" then
		local moduleName = sData.name
		local moduleHeader = "local " .. moduleName .. " = {}\n"
		
		-- Attributes
		for _, attr in ipairs(sData.attributes or {}) do
			moduleHeader ..= moduleName .. "." .. attr.name .. " = " .. (attr.value or "nil") .. "\n"
		end
		moduleHeader ..= "\n"
		
		-- We need to rebuild the code to wrap each method block
		local moduleBody = ""
		local blocks = graph:build_blocks()
		for _, b in ipairs(blocks) do
			local pNode = b.parent_node
			if pNode.Name == "Function Entry" then
				local mNameInput = pNode:getInput("__methodName")
				local mName = mNameInput and mNameInput.Value or ""
				if mName ~= "" then
					-- Find the method data to get params
					local mData = nil
					for _, m in ipairs(sData.methods or {}) do
						if m.name == mName then mData = m; break end
					end
					local params = {}
					for _, inp in ipairs(mData and mData.inputs or {}) do
						table.insert(params, inp.name)
					end
					local paramStr = table.concat(params, ", ")
					moduleBody ..= "function " .. moduleName .. ":" .. mName .. "(" .. paramStr .. ")\n" .. Block.indentCode(b:run()) .. "end\n\n"
				end
			end
		end
		
		return dependenciesCode .. moduleHeader .. moduleBody .. "return " .. moduleName .. "\n"
	else
		-- Default scripts just get the dependencies + their code
		return dependenciesCode .. code
	end
end

local function performExport(sData, variables, callback)
	local allScripts = sidebar:GetScripts()
	if sData.type == "Default" then
		ChoiceModal.prompt(widget, "Export '" .. sData.name .. "' as:", {"Script", "LocalScript"}, function(choice)
			local code = compileScriptData(sData, variables, allScripts)
			local instance = fm:ExportToScript(sData.name, choice, code)
			if callback then callback(instance) end
		end)
	else
		local code = compileScriptData(sData, variables, allScripts)
		local instance = fm:ExportToScript(sData.name, sData.type, code)
		if callback then callback(instance) end
	end
end

exportBtn:OnClick(function()
	if not projectActive or not currentScriptHandle then return end
	
	-- Save current state first
	currentScriptHandle.data.graph = currentGraph:serialize()
	
	performExport(currentScriptHandle.data, sidebar:GetVariables(), function(inst)
		canvas:SetPlaceholder("Exported '" .. inst.Name .. "' to workspace.__BlueprintExport")
		task.delay(2, function() if projectActive then canvas:HidePlaceholder() end end)
	end)
end)

exportAllBtn:OnClick(function()
	if not projectActive then return end
	
	-- Save current state first
	if currentScriptHandle then
		currentScriptHandle.data.graph = currentGraph:serialize()
	end
	
	local allScripts = sidebar:GetScripts()
	local variables = sidebar:GetVariables()
	local exportedCount = 0
	
	local function exportNext(index)
		if index > #allScripts then
			canvas:SetPlaceholder("Exported " .. exportedCount .. " scripts to workspace.__BlueprintExport")
			task.delay(3, function() if projectActive then canvas:HidePlaceholder() end end)
			return
		end
		
		local sData = allScripts[index]
		if sData.type == "Function" then
			-- Functions are now inlined into the scripts that call them
			exportNext(index + 1)
			return
		end
		
		performExport(sData, variables, function()
			exportedCount += 1
			exportNext(index + 1)
		end)
	end
	
	exportNext(1)
end)



sidebar:OnAddScript(function()
	ScriptModal.prompt(widget, nil, function(newScriptData)
		local handle = sidebar:AddScript(newScriptData, onEditScript)
		-- Automatically switch to the new script so we can start drawing!
		switchScript(handle)
	end)
end)

-- ── Sidebar: Variables ────────────────────────────────────────────────────────
sidebar:OnAddVariable(function()
	Modal.prompt(widget, "New Variable", "Variable name...", function(varName)
		addVariableToSidebar(varName)
	end)
end)

sidebar:OnScriptSelected(function(handle)
	switchScript(handle)
end)


-- ── Canvas: Mouse Tracking ──────────────────────────────────────────────────────
canvas:OnLeftClick(function()
	if not projectActive then return end
	
	-- Deselect all nodes
	for _, v in ipairs(visualNodes) do
		v:Deselect()
	end
end)



canvas:OnMouseMove(function(position)
	dragMousePos = Vector2.new(position.X, position.Y)
end)

canvas:OnKeyDown(handleKeyDown)

-- ── Keyboard Shortcuts ────────────────────────────────────────────────────────
UserInputService.InputBegan:Connect(function(input, gpe)
	-- Fallback global listener
	handleKeyDown(input.KeyCode)
end)

-- We now use OnPinDragEnd instead of UserInputService.InputEnded for robustness

RunService.Heartbeat:Connect(function()
	if wireDragging and tempWireFrame and wireStartInfo then
		local zoom = canvas:GetZoom()
		local containerPos = canvas:GetNodeContainer().AbsolutePosition
		local mousePos = dragMousePos
		
		local p1 = (wireStartInfo.pinGui.AbsolutePosition + (wireStartInfo.pinGui.AbsoluteSize / 2) - containerPos) / zoom
		
		-- Distance-based snapping
		hoveredPin = nil
		local closestDist = 45 -- Snap distance
		
		for _, vNode in ipairs(visualNodes) do
			for _, pinInfo in ipairs(vNode:GetPins()) do
				if pinInfo.pinData.Id ~= wireStartInfo.pinData.Id then
					local pinAbsolute = pinInfo.pinGui.AbsolutePosition + (pinInfo.pinGui.AbsoluteSize / 2)
					local dist = (pinAbsolute - mousePos).Magnitude
					
					if dist < closestDist then
						closestDist = dist
						hoveredPin = {
							nodeData = vNode.nodeData,
							pinData = pinInfo.pinData,
							isOutput = pinInfo.isOutput,
							pinGui = pinInfo.pinGui
						}
					end
				end
			end
		end

		local p2 = (mousePos - containerPos) / zoom
		if hoveredPin then
			-- Snap exactly to the hovered pin center
			p2 = (hoveredPin.pinGui.AbsolutePosition + (hoveredPin.pinGui.AbsoluteSize / 2) - containerPos) / zoom
		end
		
		local distance = (p2 - p1).Magnitude
		local center = (p1 + p2) / 2
		local angle = math.atan2(p2.Y - p1.Y, p2.X - p1.X)
		
		tempWireFrame.Position = UDim2.fromOffset(center.X, center.Y)
		tempWireFrame.Size = UDim2.fromOffset(distance, 3)
		tempWireFrame.Rotation = math.deg(angle)
	end
end)

-- ── Canvas: Right Click Menu & Panning ────────────────────────────────────────
canvas:OnRightClick(function(position)
	if not projectActive then return end
	
	-- Build extra nodes based on context
	local extraNodes = {}
	
	-- 1. If inside a Function script, show Entry/Return
	if currentScriptHandle and currentScriptHandle.data.type == "Function" then
		table.insert(extraNodes, {
			category = "Function Internal",
			color = Color3.fromRGB(200, 100, 50),
			items = {
				{ id = "Function Entry", name = "Function Entry", type = "Event" },
				{ id = "Function Return", name = "Function Return", type = "Method" },
			}
		})
	elseif currentScriptHandle and currentScriptHandle.data.type == "Module" then
		local methodItems = {}
		for _, m in ipairs(currentScriptHandle.data.methods or {}) do
			table.insert(methodItems, { id = "MethodEntry:" .. m.name, name = "Function Entry (" .. m.name .. ")", type = "Event" })
			table.insert(methodItems, { id = "MethodReturn:" .. m.name, name = "Function Return (" .. m.name .. ")", type = "Method" })
		end
		table.insert(extraNodes, {
			category = "Module Methods",
			color = Color3.fromRGB(200, 100, 50),
			items = methodItems
		})
	end
	
	-- 2. Show Call nodes for all Function scripts in the project
	local allScripts = sidebar:GetScripts()
	local callItems = {}
	for _, s in ipairs(allScripts) do
		if s.type == "Function" then
			table.insert(callItems, { id = "Call " .. s.name, name = "Call " .. s.name, type = "Call" })
		end
	end
	
	if #callItems > 0 then
		table.insert(extraNodes, {
			category = "Project Functions",
			color = Color3.fromRGB(100, 200, 255),
			items = callItems
		})
	end
	
	NodeMenu.prompt(widget, position, extraNodes, function(nodeId)
		spawnNode(nodeId, position)
	end)
end)

-- Ready