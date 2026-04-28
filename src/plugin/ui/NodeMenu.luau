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
			{ id = "Instance To Sound", name = "Instance To Sound", type = "Function" },
			{ id = "Instance To Camera", name = "Instance To Camera", type = "Function" },
		}
	},
	{
		category = "Methods",
		color = Color3.fromRGB(40, 100, 150),
		items = {
			{ id = "Print", name = "Print", type = "Method" }
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
			{ id = "While", name = "While Loop", type = "Control" },
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
			{ id = "Enum Material", name = "Material", type = "Enum" },
			{ id = "Enum PartType", name = "PartType", type = "Enum" },
			{ id = "Enum HumanoidStateType", name = "HumanoidStateType", type = "Enum" },
			{ id = "Enum EasingDirection", name = "EasingDirection", type = "Enum" },
			{ id = "Enum EasingStyle", name = "EasingStyle", type = "Enum" },
			{ id = "Enum CameraType", name = "CameraType", type = "Enum" },
		}
	},
	{
		category = "Modules",
		color = Color3.fromRGB(150, 100, 40),
		items = {
			{ id = "Require", name = "Require", type = "Function" },
			{ id = "Module Call", name = "Module Call", type = "Method" }
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

	local function renderList(filter)
		for _, child in scroll:GetChildren() do
			if child:IsA("GuiObject") then child:Destroy() end
		end

		filter = filter and string.lower(filter) or ""

		local layoutOrder = 0
		for _, cat in ipairs(menuData) do
			local validItems = {}
			for _, item in ipairs(cat.items) do
				if filter == "" or string.find(string.lower(item.name), filter) or string.find(string.lower(item.type), filter) then
					table.insert(validItems, item)
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
