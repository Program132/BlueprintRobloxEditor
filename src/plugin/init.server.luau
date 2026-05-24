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
local ImportModal = require(UI.ImportModal)
local UiDesigner  = require(UI.UiDesigner)
local AnimationEditor = require(UI.AnimationEditor)
local NodeMenu = require(UI.NodeMenu)
local NodeComponent = require(UI.NodeComponent)
local FunctionEntry = require(Shared.nodes.FunctionEntry)
local FunctionReturn = require(Shared.nodes.FunctionReturn)
local FunctionCall = require(Shared.nodes.FunctionCall)

local Nodes = {
	["UIEvent"]     = require(Shared.nodes.events.UIEvent),
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
	["For In Pairs"] = require(Shared.nodes.control.ForInPairs),
	["For In Ipairs"] = require(Shared.nodes.control.ForInIpairs),
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
	["Simple Tween"] = require(Shared.nodes.tween:WaitForChild("SimpleTween")),
	["Play UI Animation"] = require(Shared.nodes.tween:WaitForChild("PlayUIAnimation")),
	["Instance Workspace Object"] = require(Shared.nodes.instances:WaitForChild("WorkspaceObject")),
	["Instance new"] = require(Shared.nodes.instances:WaitForChild("New")),
	["Get Service"] = require(Shared.nodes.instances:WaitForChild("GetService")),
	["Instance Child"] = require(Shared.nodes.instances:WaitForChild("InstanceChild")),
	["Instance Get Property"] = require(Shared.nodes.instances:WaitForChild("GetProperty")),
	["Instance Set Property"] = require(Shared.nodes.instances:WaitForChild("SetProperty")),
	["Instance Script Parent"] = require(Shared.nodes.instances:WaitForChild("ScriptParent")),

	-- Ray nodes
	["Ray new"] = require(Shared.nodes.ray:WaitForChild("New")),
	["Ray ClosestPoint"] = require(Shared.nodes.ray:WaitForChild("ClosestPoint")),
	["Ray Distance"] = require(Shared.nodes.ray:WaitForChild("Distance")),
	["Ray Unit"] = require(Shared.nodes.ray:WaitForChild("Unit")),
	["Ray origin"]  = require(Shared.nodes.ray:WaitForChild("Origin")),
	["Ray direction"] = require(Shared.nodes.ray:WaitForChild("Direction")),
	["Simple Raycast"] = require(Shared.nodes.ray:WaitForChild("SimpleRaycast")),
}

local playerNodes = Shared.nodes:WaitForChild("player")
Nodes["Event Player CharacterAdded"] = require(playerNodes:WaitForChild("CharacterAdded"))
Nodes["Event Player CharacterRemoving"] = require(playerNodes:WaitForChild("CharacterRemoving"))
Nodes["Event Player Chatted"] = require(playerNodes:WaitForChild("Chatted"))
Nodes["Event Player Idled"] = require(playerNodes:WaitForChild("Idled"))
Nodes["Event Player OnTeleport"] = require(playerNodes:WaitForChild("OnTeleport"))
Nodes["Player Kick"] = require(playerNodes:WaitForChild("Kick"))
Nodes["Player Move"] = require(playerNodes:WaitForChild("Move"))
Nodes["Player LoadCharacter"] = require(playerNodes:WaitForChild("LoadCharacter"))
Nodes["Player LoadCharacterAsync"] = require(playerNodes:WaitForChild("LoadCharacterAsync"))
Nodes["Player LoadCharacterWithHumanoidDescription"] = require(playerNodes:WaitForChild("LoadCharacterWithHumanoidDescription"))
Nodes["Player LoadInstance"] = require(playerNodes:WaitForChild("LoadInstance"))
Nodes["Player AddReplicationFocus"] = require(playerNodes:WaitForChild("AddReplicationFocus"))
Nodes["Player RemoveReplicationFocus"] = require(playerNodes:WaitForChild("RemoveReplicationFocus"))
Nodes["Player RequestStreamAroundAsync"] = require(playerNodes:WaitForChild("RequestStreamAroundAsync"))
Nodes["Player ClearCharacterAppearance"] = require(playerNodes:WaitForChild("ClearCharacterAppearance"))
Nodes["Player DistanceFromCharacter"] = require(playerNodes:WaitForChild("DistanceFromCharacter"))
Nodes["Player GetFriendsOnline"] = require(playerNodes:WaitForChild("GetFriendsOnline"))
Nodes["Player GetJoinData"] = require(playerNodes:WaitForChild("GetJoinData"))
Nodes["Player GetMouse"] = require(playerNodes:WaitForChild("GetMouse"))
Nodes["Player GetNetworkPing"] = require(playerNodes:WaitForChild("GetNetworkPing"))
Nodes["Player GetRankInGroup"] = require(playerNodes:WaitForChild("GetRankInGroup"))
Nodes["Player GetRoleInGroup"] = require(playerNodes:WaitForChild("GetRoleInGroup"))
Nodes["Player HasAppearanceLoaded"] = require(playerNodes:WaitForChild("HasAppearanceLoaded"))
Nodes["Player IsBestFriendsWith"] = require(playerNodes:WaitForChild("IsBestFriendsWith"))
Nodes["Player IsFriendsWithAsync"] = require(playerNodes:WaitForChild("IsFriendsWithAsync"))
Nodes["Player IsInGroupAsync"] = require(playerNodes:WaitForChild("IsInGroupAsync"))
Nodes["Player IsVerified"] = require(playerNodes:WaitForChild("IsVerified"))
Nodes["Player SaveBoolean"] = require(playerNodes:WaitForChild("SaveBoolean"))
Nodes["Player SaveInstance"] = require(playerNodes:WaitForChild("SaveInstance"))
Nodes["Player SaveNumber"] = require(playerNodes:WaitForChild("SaveNumber"))
Nodes["Player SaveString"] = require(playerNodes:WaitForChild("SaveString"))
Nodes["Player SetAccountAge"] = require(playerNodes:WaitForChild("SetAccountAge"))
Nodes["Player SetSuperSafeChat"] = require(playerNodes:WaitForChild("SetSuperSafeChat"))
Nodes["Player WaitForDataReady"] = require(playerNodes:WaitForChild("WaitForDataReady"))

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

-- NPC nodes
local npcNodes = Shared.nodes:WaitForChild("npc")
Nodes["NPC On Death"] = require(npcNodes:WaitForChild("OnDeath"))
Nodes["NPC On Damaged"] = require(npcNodes:WaitForChild("OnDamaged"))
Nodes["NPC On Loop"] = require(npcNodes:WaitForChild("OnLoop"))
Nodes["NPC On Child Added"] = require(npcNodes:WaitForChild("OnChildAdded"))
Nodes["NPC On Child Removed"] = require(npcNodes:WaitForChild("OnChildRemoved"))
Nodes["NPC On Target Reached"] = require(npcNodes:WaitForChild("OnTargetReached"))
Nodes["NPC On State Changed"] = require(npcNodes:WaitForChild("OnStateChanged"))
Nodes["NPC Move To"] = require(npcNodes:WaitForChild("MoveTo"))
Nodes["NPC Stop Moving"] = require(npcNodes:WaitForChild("StopMoving"))
Nodes["NPC Pathfind To"] = require(npcNodes:WaitForChild("PathfindTo"))
Nodes["NPC Look At"] = require(npcNodes:WaitForChild("LookAt"))
Nodes["NPC Play Animation"] = require(npcNodes:WaitForChild("PlayAnimation"))
Nodes["NPC Stop Animation"] = require(npcNodes:WaitForChild("StopAnimation"))
Nodes["NPC Equip Tool"] = require(npcNodes:WaitForChild("EquipTool"))
Nodes["NPC Unequip Tools"] = require(npcNodes:WaitForChild("UnequipTools"))
Nodes["NPC Set WalkSpeed"] = require(npcNodes:WaitForChild("SetWalkSpeed"))
Nodes["NPC Set JumpPower"] = require(npcNodes:WaitForChild("SetJumpPower"))
Nodes["NPC Get Closest Player"] = require(npcNodes:WaitForChild("GetClosestPlayer"))
Nodes["NPC Can See Target"] = require(npcNodes:WaitForChild("CanSeeTarget"))
Nodes["NPC Respawn"] = require(npcNodes:WaitForChild("Respawn"))


-- Special nodes handled dynamically
Nodes["Function Entry"] = FunctionEntry
Nodes["Function Return"] = FunctionReturn
Nodes["Function Call"] = FunctionCall

require(Shared.ReflectionGenerator).populate(Nodes)
NodeMenu.registerNodes(Nodes)

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

local newProjectBtn  = topBar:AddButton("NewProjectBtn",  "+ New Project", "primary")
newProjectBtn:GetInstance().LayoutOrder = 1
local openProjectBtn = topBar:AddButton("OpenProjectBtn", "Open Project", "secondary")
openProjectBtn:GetInstance().LayoutOrder = 2
local saveProjectBtn = topBar:AddButton("SaveProjectBtn", "Save Project", "secondary")
saveProjectBtn:GetInstance().LayoutOrder = 3
local importBtn      = topBar:AddButton("ImportBtn",      "Import Scripts", "secondary")
importBtn:GetInstance().LayoutOrder = 4

local _separator     = topBar:AddSeparator(5)

local exportBtn      = topBar:AddButton("ExportBtn",      "Export Current", "secondary")
exportBtn:GetInstance().LayoutOrder = 6
local exportAllBtn   = topBar:AddButton("ExportAllBtn",   "Export All", "accent")
exportAllBtn:GetInstance().LayoutOrder = 7

-- UI Designer mode toggles (right aligned segmented toggle)
local modeToggle = topBar:AddSegmentedToggle("ModeToggle", {"Design", "Graph", "Animation"})
modeToggle:GetInstance().LayoutOrder = 1
modeToggle:SetVisible(false)

local editorMode = "Graph"
local uiDesigner = nil
local setEditorMode = nil
local onSwitchToGraph = nil

modeToggle:OnToggle(function(mode)
	if setEditorMode then setEditorMode(mode) end
end)

uiDesigner = UiDesigner.new(widget, function(...)
	if onSwitchToGraph then
		onSwitchToGraph(...)
	end
end)

local animationEditor = nil
animationEditor = AnimationEditor.new(widget)

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
		end
		line.BackgroundColor3 = baseColor
		line.Size = UDim2.new(line.Size.X.Scale, line.Size.X.Offset, 0, 3)
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
	elseif nodeId:sub(1, 9) == "OnAction:" or nodeId:sub(1, 14) == "OnActionBegan:" or nodeId:sub(1, 14) == "OnActionEnded:" then
		local actionName
		local title
		if nodeId:sub(1, 14) == "OnActionBegan:" then
			actionName = nodeId:sub(15)
			title = "On Action Began: " .. actionName
		elseif nodeId:sub(1, 14) == "OnActionEnded:" then
			actionName = nodeId:sub(15)
			title = "On Action Ended: " .. actionName
		else
			actionName = nodeId:sub(10)
			title = "On Action Began: " .. actionName
		end
		
		local Node = require(Shared.Node)
		local NodeType = require(Shared.NodeType)
		local IO = require(Shared.IO)
		
		nodeInstance = Node.new(title, NodeType.EVENT)
		nodeInstance.Title = title
		nodeInstance:addOutput(IO.Output.new("Exec", ""))
		
		function nodeInstance:toLuau(block, visited)
			return block:run_from_port(nodeInstance, "Exec", visited)
		end
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
		nodeInstance = nodeClass.new(nil, { script = currentScriptHandle and currentScriptHandle.data, projectScripts = sidebar:GetScripts() })
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


setEditorMode = function(mode)
	editorMode = mode
	if not modeToggle then return end
	
	modeToggle:Select(mode)
	
	if editorMode == "Design" then
		sidebar:GetInstance().Visible = false
		canvas:GetInstance().Visible = false
		if animationEditor then
			animationEditor:GetInstance().Visible = false
			animationEditor:SaveState()
		end
		if uiDesigner then
			uiDesigner:GetInstance().Visible = true
			if currentScriptHandle then
				uiDesigner:LoadScript(currentScriptHandle.data, currentGraph)
			end
		end
	elseif editorMode == "Animation" then
		sidebar:GetInstance().Visible = false
		canvas:GetInstance().Visible = false
		if uiDesigner then
			uiDesigner:GetInstance().Visible = false
			uiDesigner:SaveState()
		end
		if animationEditor then
			animationEditor:GetInstance().Visible = true
			if currentScriptHandle then
				animationEditor:LoadScript(currentScriptHandle.data)
			end
		end
	else
		sidebar:GetInstance().Visible = true
		canvas:GetInstance().Visible = true
		if uiDesigner then
			uiDesigner:GetInstance().Visible = false
			uiDesigner:SaveState()
		end
		if animationEditor then
			animationEditor:GetInstance().Visible = false
			animationEditor:SaveState()
		end
		
		clearCanvas()
		if currentGraph then
			-- Update dropdowns for Play UI Animation
			if currentScriptHandle and currentScriptHandle.data.type == "UI" then
				local animNames = {}
				for _, anim in ipairs(currentScriptHandle.data.animations or {}) do
					table.insert(animNames, anim.name)
				end
				for _, node in pairs(currentGraph.nodes) do
					if node.Name == "Play UI Animation" then
						local animInput = node:getInput("AnimationName")
						if animInput then
							animInput.Choices = animNames
						end
					end
				end
			end
			renderGraph(currentGraph)
		end
	end
end

onSwitchToGraph = function(nodeInstance)
	setEditorMode("Graph")
	task.wait()
	
	local targetVisualNode = nil
	for _, vNode in ipairs(visualNodes) do
		if vNode.nodeData == nodeInstance then
			targetVisualNode = vNode
			break
		end
	end
	
	if targetVisualNode then
		targetVisualNode:Select()
		canvas:CenterOnPosition(nodeInstance.Position)
	end
end


local function centerOnFirstNode()
	if not projectActive or not currentGraph then return end
	
	local targetNode = nil
	for _, node in pairs(currentGraph.nodes) do
		if node.Type == "EVENT" then
			targetNode = node
			break
		end
	end
	if not targetNode then
		for _, node in pairs(currentGraph.nodes) do
			targetNode = node
			break
		end
	end
	
	if targetNode then
		canvas:CenterOnPosition(targetNode.Position)
	else
		canvas:CenterOnPosition(Vector2.zero)
	end
end

local function switchScript(handle)
	if not projectActive then return end
	
	-- 1. Save current state to the old handle
	if currentScriptHandle then
		if currentScriptHandle.data.type == "UI" then
			if uiDesigner then uiDesigner:SaveState() end
			if animationEditor then animationEditor:SaveState() end
		end
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
	
	-- 5. Show/hide UI Designer elements
	if modeToggle then
		if handle.data.type == "UI" then
			modeToggle:SetVisible(true)
			setEditorMode(editorMode)
		else
			modeToggle:SetVisible(false)
			setEditorMode("Graph")
		end
	else
		renderGraph(currentGraph)
	end
	
	task.defer(centerOnFirstNode)
end


-- Ready


-- ── Sidebar: Scripts ──────────────────────────────────────────────────────────
local function onEditScript(handle)
	ScriptModal.prompt(widget, handle.data, function(updatedData)
		-- Update the data
		handle.data = updatedData
		-- Update UI
		handle.nameLabel.Text = updatedData.name
		
		local typeStr = "DEF"
		local tagBg = Color3.fromRGB(30, 40, 60)
		local tagFg = Color3.fromRGB(110, 160, 240)

		if updatedData.type == "Function" then
			typeStr = "FUN"
			tagBg = Color3.fromRGB(30, 60, 50)
			tagFg = Color3.fromRGB(90, 200, 150)
		elseif updatedData.type == "Module" then
			typeStr = "MOD"
			tagBg = Color3.fromRGB(60, 30, 60)
			tagFg = Color3.fromRGB(200, 90, 200)
		elseif updatedData.type == "Tool" then
			typeStr = "TOL"
			tagBg = Color3.fromRGB(80, 50, 20)
			tagFg = Color3.fromRGB(250, 160, 50)
		elseif updatedData.type == "NPC" then
			typeStr = "NPC"
			tagBg = Color3.fromRGB(20, 60, 60)
			tagFg = Color3.fromRGB(50, 220, 220)
		elseif updatedData.type == "UI" then
			typeStr = "UI "
			tagBg = Color3.fromRGB(45, 30, 80)
			tagFg = Color3.fromRGB(180, 120, 255)
		end

		handle.typeBtn.Text = typeStr
		handle.typeBtn.BackgroundColor3 = tagBg
		handle.typeBtn.TextColor3 = tagFg
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
		if currentScriptHandle.data.type == "UI" then
			if uiDesigner then uiDesigner:SaveState() end
			if animationEditor then animationEditor:SaveState() end
		end
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

-- ── Import Scripts ─────────────────────────────────────────────────────────────
importBtn:OnClick(function()
	if not projectActive then return end

	local project = fm:OpenJSON({"json"})
	if project == nil or project.data == nil or project.data.scripts == nil then return end

	ImportModal.prompt(widget, project.data.scripts, function(selectedScripts)
		-- Check name collisions and rename if necessary
		local currentScripts = sidebar:GetScripts()
		for _, sData in ipairs(selectedScripts) do
			local baseName = sData.name or "Script"
			local name = baseName
			local count = 0
			
			local function isNameColliding(checkName)
				for _, curScript in ipairs(currentScripts) do
					if curScript.name == checkName then
						return true
					end
				end
				return false
			end

			while isNameColliding(name) do
				count += 1
				name = baseName .. "_" .. count
			end

			sData.name = name
			
			-- Add the script to the sidebar
			local handle = sidebar:AddScript(sData, onEditScript)
			handle.data.variables = sData.variables or {}
			handle.data.graph = sData.graph
			
			-- Add it to our current list of scripts to prevent subsequent imports in the same batch from colliding with each other
			table.insert(currentScripts, sData)
		end
		
		-- Save the newly imported scripts into the project representation/export
		local data = gatherProjectData()
		fm:ExportToStringValue(data)
		
		canvas:SetPlaceholder("Successfully imported " .. #selectedScripts .. " script(s)!")
		task.delay(3, function()
			if projectActive then canvas:HidePlaceholder() end
		end)
	end)
end)

-- ── Export Logic ──────────────────────────────────────────────────────────────

local function serializeValue(val, propertyName)
	if typeof(val) == "table" then
		if propertyName == "CornerRadius" or propertyName == "PaddingTop" or propertyName == "PaddingBottom" or propertyName == "PaddingLeft" or propertyName == "PaddingRight" or propertyName == "Padding" then
			return "UDim.new(" .. table.concat(val, ", ") .. ")"
		elseif #val == 4 then
			return "UDim2.new(" .. table.concat(val, ", ") .. ")"
		elseif #val == 2 then
			return "Vector2.new(" .. table.concat(val, ", ") .. ")"
		elseif #val == 3 then
			return "Color3.fromRGB(" .. val[1] .. ", " .. val[2] .. ", " .. val[3] .. ")"
		end
	elseif typeof(val) == "boolean" or typeof(val) == "number" then
		return tostring(val)
	elseif typeof(val) == "string" then
		local HttpService = game:GetService("HttpService")
		local ENUM_MAPPINGS = {
			MajorAxis = "TableMajorAxis",
			DragStyle = "DragDetectorDragStyle",
			ResponseStyle = "DragDetectorResponseStyle",
			FlexMode = "UIFlexMode",
		}
		local UI_ENUM_TYPES = {
			Font = true, TextXAlignment = true, TextYAlignment = true,
			FillDirection = true, HorizontalAlignment = true, VerticalAlignment = true,
			SortOrder = true, ApplyStrokeMode = true, LineJoinMode = true,
			AspectType = true, DominantAxis = true, DragDetectorDragStyle = true,
			DragDetectorResponseStyle = true, UIFlexMode = true, EasingDirection = true,
			EasingStyle = true, TableMajorAxis = true, StartCorner = true
		}
		local enumName = ENUM_MAPPINGS[propertyName] or propertyName
		if UI_ENUM_TYPES[enumName] then
			return "Enum." .. enumName .. "." .. val
		else
			return HttpService:JSONEncode(val)
		end
	end
	return "nil"
end

local function compileAnimations(sData)
	local anims = sData.animations or {}
	if #anims == 0 then return "" end

	local HttpService = game:GetService("HttpService")
	local code = "-- Play Animation functions\n"
	for _, anim in ipairs(anims) do
		local safeAnimName = anim.name:gsub("[^%w_]", "")
		if safeAnimName == "" then safeAnimName = "Anim" end
		
		code ..= "local function PlayAnimation_" .. safeAnimName .. "(customDuration)\n"
		code ..= "\tlocal duration = customDuration or " .. (anim.duration or 1.0) .. "\n"
		code ..= "\tlocal TweenService = game:GetService(\"TweenService\")\n\n"

		for _, track in ipairs(anim.tracks or {}) do
			if #track.keyframes > 0 then
				code ..= "\ttask.spawn(function()\n"
				
				local kfs = {}
				for _, kf in ipairs(track.keyframes) do table.insert(kfs, kf) end
				table.sort(kfs, function(a, b) return a.time < b.time end)
				
				local startVal = serializeValue(kfs[1].value, track.property)
				code ..= "\t\t" .. track.elementName .. "." .. track.property .. " = " .. startVal .. "\n"
				
				for i = 2, #kfs do
					local prev = kfs[i-1]
					local curr = kfs[i]
					local diff = curr.time - prev.time
					if diff > 0 then
						local targetVal = serializeValue(curr.value, track.property)
						local style = curr.easingStyle or "Quad"
						local dir = curr.easingDirection or "Out"
						
						code ..= "\t\tlocal t" .. (i-1) .. " = TweenService:Create(" .. track.elementName 
							.. ", TweenInfo.new(" .. diff .. " * (duration / " .. (anim.duration or 1.0) .. "), Enum.EasingStyle." .. style .. ", Enum.EasingDirection." .. dir .. "), "
							.. "{[" .. HttpService:JSONEncode(track.property) .. "] = " .. targetVal .. "})\n"
						code ..= "\t\tt" .. (i-1) .. ":Play()\n"
						code ..= "\t\tt" .. (i-1) .. ".Completed:Wait()\n"
					end
				end
				
				code ..= "\tend)\n\n"
			end
		end

		code ..= "end\n\n"
	end

	return code
end

local function compileScriptData(sData, variables, allScripts, alreadyInlined)
	alreadyInlined = alreadyInlined or {}
	if alreadyInlined[sData.name] then return "" end -- Already inlined
	
	-- 1. Restore the graph to find dependencies
	local graph
	if sData.graph then
		local context = { script = sData, projectScripts = allScripts }
		graph = Graph.from_data(sData.graph, Nodes, context)
	else
		graph = Graph.new()
	end
	
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
	elseif sData.type == "Tool" then
		local header = "-- Tool Script: " .. sData.name .. "\n"
		header ..= "local UIS = game:GetService(\"UserInputService\")\n"
		header ..= "local tool = script.Parent\n"
		header ..= "local toolIsEquipped = false\n\n"
		
		header ..= "tool.Equipped:Connect(function()\n"
		header ..= "\ttoolIsEquipped = true\n"
		header ..= "end)\n\n"
		
		header ..= "tool.Unequipped:Connect(function()\n"
		header ..= "\ttoolIsEquipped = false\n"
		header ..= "end)\n\n"
		
		local varsCode = ""
		local sortedVars = {}
		local usedVars = {}
		if variables then
			for _, name in ipairs(variables) do
				usedVars[name] = true
			end
		end
		for _, node in pairs(graph.nodes) do
			if node.Name == "Get Variable" or node.Name == "Set Variable" then
				local nameInput = node:getInput("name")
				if nameInput and nameInput.Value ~= "" then
					usedVars[nameInput.Value] = true
				end
			end
		end
		for varName, _ in pairs(usedVars) do
			table.insert(sortedVars, varName)
		end
		table.sort(sortedVars)
		for _, varName in ipairs(sortedVars) do
			varsCode ..= "local var_" .. varName .. " = nil\n"
		end
		if varsCode ~= "" then
			varsCode ..= "\n"
		end
		
		local blocks = graph:build_blocks()
		
		-- 1. InputBegan
		local beganActionsCode = ""
		for _, action in ipairs(sData.actions or {}) do
			local actionBlock = nil
			for _, b in ipairs(blocks) do
				local pNode = b.parent_node
				if pNode.Class == "OnActionBegan:" .. action.name or pNode.Class == "OnAction:" .. action.name then
					actionBlock = b
					break
				end
			end
			
			if actionBlock then
				local runCode = actionBlock:run()
				if runCode ~= "" then
					beganActionsCode ..= "if input.KeyCode == Enum.KeyCode." .. action.key .. " then\n"
					beganActionsCode ..= Block.indentCode(runCode)
					beganActionsCode ..= "end\n\n"
				end
			end
		end
		
		local inputBegan = ""
		if beganActionsCode ~= "" then
			inputBegan ..= "UIS.InputBegan:Connect(function(input, gameProcess)\n"
			inputBegan ..= "\tif gameProcess then return end\n"
			inputBegan ..= "\tif not toolIsEquipped then return end\n\n"
			inputBegan ..= Block.indentCode(beganActionsCode)
			inputBegan ..= "end)\n\n"
		end
		
		-- 2. InputEnded
		local endedActionsCode = ""
		for _, action in ipairs(sData.actions or {}) do
			local actionBlock = nil
			for _, b in ipairs(blocks) do
				local pNode = b.parent_node
				if pNode.Class == "OnActionEnded:" .. action.name then
					actionBlock = b
					break
				end
			end
			
			if actionBlock then
				local runCode = actionBlock:run()
				if runCode ~= "" then
					endedActionsCode ..= "if input.KeyCode == Enum.KeyCode." .. action.key .. " then\n"
					endedActionsCode ..= Block.indentCode(runCode)
					endedActionsCode ..= "end\n\n"
				end
			end
		end
		
		local inputEnded = ""
		if endedActionsCode ~= "" then
			inputEnded ..= "UIS.InputEnded:Connect(function(input, gameProcess)\n"
			inputEnded ..= "\tif gameProcess then return end\n"
			inputEnded ..= "\tif not toolIsEquipped then return end\n\n"
			inputEnded ..= Block.indentCode(endedActionsCode)
			inputEnded ..= "end)\n\n"
		end
		
		-- 3. General (non-action) blocks, like Event UserInputService InputEnded/Began, Event Players PlayerAdded, etc.
		local otherBlocksCode = ""
		for _, b in ipairs(blocks) do
			local pNode = b.parent_node
			local isActionBlock = false
			for _, action in ipairs(sData.actions or {}) do
				if pNode.Class == "OnActionBegan:" .. action.name 
					or pNode.Class == "OnActionEnded:" .. action.name 
					or pNode.Class == "OnAction:" .. action.name then
					isActionBlock = true
					break
				end
			end
			if not isActionBlock then
				local runCode = b:run()
				if runCode ~= "" then
					otherBlocksCode ..= runCode .. "\n"
				end
			end
		end

		local actionsCompiled = inputBegan .. inputEnded
		if actionsCompiled == "" and otherBlocksCode == "" then
			actionsCompiled = "-- No action logic defined\n"
		else
			actionsCompiled ..= otherBlocksCode
		end
		
		return dependenciesCode .. header .. varsCode .. actionsCompiled
	elseif sData.type == "NPC" then
		local header = "-- NPC Script: " .. sData.name .. "\n"
		header ..= "local Players = game:GetService(\"Players\")\n"
		header ..= "local PathfindingService = game:GetService(\"PathfindingService\")\n\n"
		
		local charPath = sData.characterPath or "script.Parent"
		if charPath == "" then charPath = "script.Parent" end
		header ..= "local char = " .. charPath .. "\n"
		
		local humPath = sData.humanoidPath or "Humanoid"
		if humPath == "" then humPath = "Humanoid" end
		
		local humResolver = ""
		if humPath:sub(1, 4) == "char" or humPath:sub(1, 6) == "script" then
			humResolver = humPath
		elseif humPath:find("%.") or humPath:find(":") or humPath:find("/") then
			humResolver = "char." .. humPath
		else
			humResolver = "char:WaitForChild(\"" .. humPath .. "\")"
		end
		
		header ..= "local humanoid = " .. humResolver .. "\n\n"
		
		local hasRespawn = false
		for _, node in pairs(graph.nodes) do
			if node.Name == "NPC Respawn" then
				hasRespawn = true
				break
			end
		end
		if hasRespawn then
			header ..= "local player = Players:GetPlayerFromCharacter(char)\n"
			header ..= "if player then\n"
			header ..= "\tif not player:HasAppearanceLoaded() then\n"
			header ..= "\t\tplayer.CharacterAppearanceLoaded:Wait()\n"
			header ..= "\tend\n"
			header ..= "else\n"
			header ..= "\tchar:WaitForChild(\"HumanoidRootPart\", 5)\n"
			header ..= "\ttask.wait(0.2)\n"
			header ..= "end\n\n"
			header ..= "local existingBackup = game:GetService(\"ServerStorage\"):FindFirstChild(char.Name .. \"_backup\")\n"
			header ..= "if not existingBackup then\n"
			header ..= "\tlocal wasArchivable = char.Archivable\n"
			header ..= "\tchar.Archivable = true\n"
			header ..= "\tlocal wasArchivableParts = {}\n"
			header ..= "\tfor _, child in pairs(char:GetChildren()) do\n"
			header ..= "\t\tif child:IsA(\"BasePart\") then\n"
			header ..= "\t\t\twasArchivableParts[child] = child.Archivable\n"
			header ..= "\t\t\tchild.Archivable = true\n"
			header ..= "\t\t\tend\n"
			header ..= "\tend\n"
			header ..= "\tlocal backup = char:Clone()\n"
			header ..= "\tchar.Archivable = wasArchivable\n"
			header ..= "\tfor child, wasArchivable in pairs(wasArchivableParts) do\n"
			header ..= "\t\tchild.Archivable = wasArchivable\n"
			header ..= "\tend\n"
			header ..= "\tif backup then\n"
			header ..= "\t\tbackup.Name = char.Name .. \"_backup\"\n"
			header ..= "\t\tbackup.Parent = game:GetService(\"ServerStorage\")\n"
			header ..= "\tend\n"
			header ..= "end\n\n"
		end
		
		return dependenciesCode .. header .. code
	elseif sData.type == "UI" then
		local header = "-- UI Script: " .. sData.name .. "\n"
		header ..= "local Players = game:GetService(\"Players\")\n"
		header ..= "local localPlayer = Players.LocalPlayer\n"
		header ..= "local PlayerGui = localPlayer:WaitForChild(\"PlayerGui\")\n\n"
		
		-- Gather all element names for local declarations
		local elemNames = {}
		local function gatherNames(elements)
			for _, el in ipairs(elements) do
				table.insert(elemNames, el.name)
				if el.children then
					gatherNames(el.children)
				end
			end
		end
		if sData.uiElements then
			gatherNames(sData.uiElements)
		end
		
		local declsCode = "-- UI Elements local declarations\n"
		local hasDecls = false
		for _, name in ipairs(elemNames) do
			declsCode ..= "local " .. name .. " = nil\n"
			hasDecls = true
		end
		if hasDecls then
			declsCode ..= "\n"
		else
			declsCode = ""
		end
		
		-- Create the ScreenGui and elements recursively
		local creationCode = "-- Create UI Hierarchy\n"
		creationCode ..= "local screenGui = Instance.new(\"ScreenGui\")\n"
		creationCode ..= "screenGui.Name = \"" .. sData.name .. "\"\n"
		creationCode ..= "screenGui.ResetOnSpawn = false\n"
		creationCode ..= "screenGui.Parent = PlayerGui\n\n"
		
		local HttpService = game:GetService("HttpService")
		local ENUM_MAPPINGS = {
			MajorAxis = "TableMajorAxis",
			DragStyle = "DragDetectorDragStyle",
			ResponseStyle = "DragDetectorResponseStyle",
			FlexMode = "UIFlexMode",
		}
		local UI_ENUM_TYPES = {
			Font = true, TextXAlignment = true, TextYAlignment = true,
			FillDirection = true, HorizontalAlignment = true, VerticalAlignment = true,
			SortOrder = true, ApplyStrokeMode = true, LineJoinMode = true,
			AspectType = true, DominantAxis = true, DragDetectorDragStyle = true,
			DragDetectorResponseStyle = true, UIFlexMode = true, EasingDirection = true,
			EasingStyle = true, TableMajorAxis = true, StartCorner = true
		}
		local function genElCode(el, parentVarName)
			local varName = el.name
			local lines = {}
			table.insert(lines, varName .. " = Instance.new(\"" .. el.class .. "\")")
			table.insert(lines, varName .. ".Name = \"" .. el.name .. "\"")
			for p, val in pairs(el.properties or {}) do
				if typeof(val) == "table" then
					if p == "CornerRadius" or p == "PaddingTop" or p == "PaddingBottom" or p == "PaddingLeft" or p == "PaddingRight" or p == "Padding" then
						table.insert(lines, varName .. "." .. p .. " = UDim.new(" .. table.concat(val, ", ") .. ")")
					elseif #val == 4 then
						table.insert(lines, varName .. "." .. p .. " = UDim2.new(" .. table.concat(val, ", ") .. ")")
					elseif #val == 2 then
						table.insert(lines, varName .. "." .. p .. " = Vector2.new(" .. table.concat(val, ", ") .. ")")
					elseif #val == 3 then
						table.insert(lines, varName .. "." .. p .. " = Color3.fromRGB(" .. val[1] .. ", " .. val[2] .. ", " .. val[3] .. ")")
					end
				elseif typeof(val) == "boolean" or typeof(val) == "number" then
					table.insert(lines, varName .. "." .. p .. " = " .. tostring(val))
				elseif typeof(val) == "string" then
					local enumName = ENUM_MAPPINGS[p] or p
					if UI_ENUM_TYPES[enumName] then
						table.insert(lines, varName .. "." .. p .. " = Enum." .. enumName .. "." .. val)
					else
						table.insert(lines, varName .. "." .. p .. " = " .. HttpService:JSONEncode(val))
					end
				end
			end
			
			table.insert(lines, varName .. ".Parent = " .. parentVarName)
			table.insert(lines, "")
			
			local blockCode = table.concat(lines, "\n")
			if el.children then
				for _, child in ipairs(el.children) do
					blockCode ..= genElCode(child, varName)
				end
			end
			return blockCode
		end
		
		if sData.uiElements then
			for _, el in ipairs(sData.uiElements) do
				creationCode ..= genElCode(el, "screenGui")
			end
		end
		
		local animCode = compileAnimations(sData)
		return dependenciesCode .. header .. declsCode .. creationCode .. animCode .. code
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
	elseif sData.type == "Tool" then
		local code = compileScriptData(sData, variables, allScripts)
		local instance = fm:ExportToScript(sData.name, "LocalScript", code)
		if callback then callback(instance) end
	elseif sData.type == "UI" then
		local code = compileScriptData(sData, variables, allScripts)
		local instance = fm:ExportToScript(sData.name, "LocalScript", code)
		if callback then callback(instance) end
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
canvas:OnResetView(centerOnFirstNode)

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
	elseif currentScriptHandle and currentScriptHandle.data.type == "Tool" then
		local actionItems = {}
		for _, action in ipairs(currentScriptHandle.data.actions or {}) do
			table.insert(actionItems, { id = "OnActionBegan:" .. action.name, name = "On Action Began: " .. action.name, type = "Event" })
			table.insert(actionItems, { id = "OnActionEnded:" .. action.name, name = "On Action Ended: " .. action.name, type = "Event" })
		end
		if #actionItems > 0 then
			table.insert(extraNodes, {
				category = "Tool Actions",
				color = Color3.fromRGB(240, 140, 40),
				items = actionItems
			})
		end
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
	
	local scriptType = currentScriptHandle and currentScriptHandle.data.type or "Default"
	NodeMenu.prompt(widget, position, extraNodes, scriptType, function(nodeId)
		spawnNode(nodeId, position)
	end)
end)

-- Ready
