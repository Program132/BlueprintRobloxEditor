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
			{ id = "Add", name = "Add", type = "Function" }
		}
	},
	{
		category = "Variables",
		color = Color3.fromRGB(180, 130, 40),
		items = {
			{ id = "Get Variable", name = "GET (Variable)", type = "Variable" },
			{ id = "Set Variable", name = "SET (Variable)", type = "Variable" }
		}
	}
}

function NodeMenu.prompt(parent, position, onSelect)
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
		for _, cat in ipairs(NODES_DATA) do
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
