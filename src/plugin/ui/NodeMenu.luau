-- NodeMenu: A searchable dropdown menu for adding nodes
-- This module handles the registration of available nodes and provides a UI for searching/selecting them.

local NodeMenu = {}

local registeredNodes = {}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

function NodeMenu.registerNodes(nodes)
	registeredNodes = nodes
end

function NodeMenu.prompt(parent, position, extraNodes, scriptType, onConfirm)
	-- 1. Create Overlay
	local overlay = Instance.new("TextButton")
	overlay.Name = "NodeMenuOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundTransparency = 1
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.ZIndex = 100
	overlay.Parent = parent

	-- 2. Main Menu Container
	local menu = Instance.new("Frame")
	menu.Name = "NodeMenuContainer"
	menu.Size = UDim2.new(0, 320, 0, 450)
	
	-- Position adjustment to keep menu in view
	local x = math.min(position.X, parent.AbsoluteSize.X - 320)
	local y = math.min(position.Y, parent.AbsoluteSize.Y - 450)
	menu.Position = UDim2.fromOffset(x, y)
	menu.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
	menu.BorderSizePixel = 0
	menu.ZIndex = 101
	menu.Parent = parent
	makeCorner(menu, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 70, 110)
	stroke.Thickness = 1.5
	stroke.Parent = menu

	-- Gradient background
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 30, 48)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 20, 32))
	})
	gradient.Rotation = 45
	gradient.Parent = menu

	-- 3. Search Bar
	local searchContainer = Instance.new("Frame")
	searchContainer.Name = "SearchContainer"
	searchContainer.Size = UDim2.new(1, -24, 0, 40)
	searchContainer.Position = UDim2.new(0, 12, 0, 12)
	searchContainer.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
	searchContainer.BorderSizePixel = 0
	searchContainer.ZIndex = 102
	searchContainer.Parent = menu
	makeCorner(searchContainer, 8)

	local searchIcon = Instance.new("ImageLabel")
	searchIcon.Size = UDim2.new(0, 20, 0, 20)
	searchIcon.Position = UDim2.new(0, 10, 0.5, -10)
	searchIcon.BackgroundTransparency = 1
	searchIcon.Image = "rbxassetid://6031280260"
	searchIcon.ImageColor3 = Color3.fromRGB(100, 120, 160)
	searchIcon.ZIndex = 103
	searchIcon.Parent = searchContainer

	local searchInput = Instance.new("TextBox")
	searchInput.Name = "SearchInput"
	searchInput.Size = UDim2.new(1, -45, 1, 0)
	searchInput.Position = UDim2.new(0, 40, 0, 0)
	searchInput.BackgroundTransparency = 1
	searchInput.Text = ""
	searchInput.PlaceholderText = "Type to search nodes..."
	searchInput.TextColor3 = Color3.fromRGB(230, 240, 255)
	searchInput.PlaceholderColor3 = Color3.fromRGB(70, 90, 120)
	searchInput.TextSize = 14
	searchInput.Font = Enum.Font.Gotham
	searchInput.TextXAlignment = Enum.TextXAlignment.Left
	searchInput.ClearTextOnFocus = false
	searchInput.ZIndex = 103
	searchInput.Parent = searchContainer
	searchInput:CaptureFocus()

	-- 4. Results List
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "ResultsList"
	scroll.Size = UDim2.new(1, -12, 1, -70)
	scroll.Position = UDim2.new(0, 6, 0, 62)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 5
	scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 80, 120)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ZIndex = 102
	scroll.Parent = menu

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = scroll

	local function close()
		overlay:Destroy()
		menu:Destroy()
	end

	overlay.MouseButton1Click:Connect(close)

	-- 5. Helper: Node Processing & Measurement
	local TextService = game:GetService("TextService")
	
	local MANUAL_CATEGORIES = {
		["Abs"] = "Math", ["Sin"] = "Math", ["Cos"] = "Math", ["Tan"] = "Math",
		["Asin"] = "Math", ["Acos"] = "Math", ["Atan"] = "Math", ["Atan2"] = "Math",
		["Sqrt"] = "Math", ["Floor"] = "Math", ["Ceil"] = "Math", ["Min"] = "Math", ["Max"] = "Math",
		["Random"] = "Math", ["Pi"] = "Math", ["Huge"] = "Math", ["Pow"] = "Math",
		["Log"] = "Math", ["Exp"] = "Math", ["Rad"] = "Math", ["Deg"] = "Math",
		["Print"] = "Output", ["Warn"] = "Output", ["Error"] = "Output",
		["Return"] = "Control", ["If"] = "Control", ["While"] = "Control", ["For"] = "Control",
		["For In Pairs"] = "Control", ["For In Ipairs"] = "Control",
		["Play UI Animation"] = "Tween",
	}

	local function getNodeInfo(key)
		local category = MANUAL_CATEGORIES[key]
		local displayName = key
		local color = Color3.fromRGB(150, 170, 200)

		if not category then
			local firstSpace = key:find(" ")
			if firstSpace then
				category = key:sub(1, firstSpace - 1)
				displayName = key:sub(firstSpace + 1)
			else
				category = "General"
			end
		end

		-- Premium category colors
		if category == "Vector3" or category == "Vector2" then color = Color3.fromRGB(255, 230, 100)
		elseif category == "CFrame" then color = Color3.fromRGB(255, 180, 100)
		elseif category == "String" then color = Color3.fromRGB(255, 120, 200)
		elseif category == "Math" or category == "Boolean" then color = Color3.fromRGB(120, 200, 255)
		elseif category == "Table" then color = Color3.fromRGB(180, 120, 255)
		elseif category == "Event" then color = Color3.fromRGB(255, 80, 80)
		elseif category == "Instance" or category == "Player" or category == "Players" then color = Color3.fromRGB(100, 255, 180)
		elseif category == "NPC" then color = Color3.fromRGB(80, 240, 240)
		elseif category == "Task" then color = Color3.fromRGB(200, 100, 255)
		elseif category == "Output" then color = Color3.fromRGB(255, 100, 50)
		elseif category == "Simple" then color = Color3.fromRGB(230, 80, 150)
		elseif category == "Tween" or category == "TweenInfo" then color = Color3.fromRGB(255, 130, 0)
		elseif category == "Ray" then color = Color3.fromRGB(130, 80, 250)
		elseif category:find("Service") then color = Color3.fromRGB(255, 150, 50)
		end

		return displayName, category, color
	end

	-- 6. Item Creation
	local function createItem(id, name, category, color)
		local btn = Instance.new("TextButton")
		btn.Name = "NodeItem_" .. id
		btn.Size = UDim2.new(1, -10, 0, 36)
		btn.BackgroundColor3 = Color3.fromRGB(32, 40, 58)
		btn.BorderSizePixel = 0
		btn.Text = ""
		btn.AutoButtonColor = true
		btn.ZIndex = 103
		btn.Parent = scroll
		makeCorner(btn, 6)

		-- Source Badge (The [Service] part)
		local badge = Instance.new("Frame")
		badge.Name = "SourceBadge"
		local badgeText = category:upper()
		local textSize = TextService:GetTextSize(badgeText, 9, Enum.Font.GothamBold, Vector2.new(200, 20)).X + 12
		badge.Size = UDim2.fromOffset(textSize, 18)
		badge.Position = UDim2.new(0, 8, 0.5, -9)
		badge.BackgroundColor3 = color
		badge.BackgroundTransparency = 0.2
		badge.ZIndex = 104
		badge.Parent = btn
		makeCorner(badge, 4)

		local badgeLabel = Instance.new("TextLabel")
		badgeLabel.Size = UDim2.new(1, 0, 1, 0)
		badgeLabel.BackgroundTransparency = 1
		badgeLabel.Text = badgeText
		badgeLabel.TextColor3 = Color3.new(0, 0, 0)
		badgeLabel.TextTransparency = 0.3
		badgeLabel.TextSize = 9
		badgeLabel.Font = Enum.Font.GothamBold
		badgeLabel.ZIndex = 105
		badgeLabel.Parent = badge

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(1, -textSize - 25, 1, 0)
		nameLabel.Position = UDim2.new(0, textSize + 15, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = name
		nameLabel.TextColor3 = Color3.fromRGB(235, 245, 255)
		nameLabel.TextSize = 13
		nameLabel.Font = Enum.Font.GothamMedium
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.ZIndex = 104
		nameLabel.Parent = btn

		btn.MouseButton1Click:Connect(function()
			close()
			onConfirm(id)
		end)

		btn.MouseEnter:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(55, 70, 110)
			badge.BackgroundTransparency = 0
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(32, 40, 58)
			badge.BackgroundTransparency = 0.2
		end)
		
		-- Return width needed for this item
		local fullWidth = textSize + TextService:GetTextSize(name, 13, Enum.Font.GothamMedium, Vector2.new(1000, 40)).X + 40
		return btn, fullWidth
	end

	local function createHeader(text, color)
		local header = Instance.new("TextLabel")
		header.Size = UDim2.new(1, -10, 0, 28)
		header.BackgroundTransparency = 1
		header.Text = "  " .. text:upper()
		header.TextColor3 = color or Color3.fromRGB(110, 140, 190)
		header.TextSize = 11
		header.Font = Enum.Font.GothamBold
		header.TextXAlignment = Enum.TextXAlignment.Left
		header.ZIndex = 103
		header.Parent = scroll
		
		local width = TextService:GetTextSize(text:upper(), 11, Enum.Font.GothamBold, Vector2.new(1000, 40)).X + 30
		return header, width
	end

	-- 7. List Management & Dynamic Resizing
	local function updateList(filter)
		for _, child in ipairs(scroll:GetChildren()) do
			if child:IsA("Frame") or child:IsA("TextButton") or child:IsA("TextLabel") then
				child:Destroy()
			end
		end

		local itemsCount = 0
		local filterLower = filter:lower()
		local maxContentWidth = 200 -- Min width

		local function processItem(id, name, cat, color)
			local _, w = createItem(id, name, cat, color)
			if w > maxContentWidth then maxContentWidth = w end
			itemsCount += 1
		end

		local function processHeader(text, color)
			local _, w = createHeader(text, color)
			if w > maxContentWidth then maxContentWidth = w end
			itemsCount += 1
		end

		if filter == "" then
			if extraNodes then
				for _, catGroup in ipairs(extraNodes) do
					processHeader(catGroup.category, catGroup.color)
					for _, item in ipairs(catGroup.items) do
						processItem(item.id, item.name, catGroup.category, catGroup.color or Color3.fromRGB(150, 170, 200))
					end
				end
			end

			-- Group registered nodes by category
			local nodesByCategory = {}
			local categories = {}
			
			for key, _ in pairs(registeredNodes) do
				local displayName, category, color = getNodeInfo(key)
				if category == "NPC" and scriptType ~= "NPC" then
					continue
				end
				if not nodesByCategory[category] then
					nodesByCategory[category] = {color = color, items = {}}
					table.insert(categories, category)
				end
				table.insert(nodesByCategory[category].items, {id = key, name = displayName})
			end
			table.sort(categories)

			for _, cat in ipairs(categories) do
				local group = nodesByCategory[cat]
				processHeader(cat, group.color:Lerp(Color3.new(0.8, 0.8, 1), 0.2))
				
				table.sort(group.items, function(a, b) return a.name < b.name end)
				for _, item in ipairs(group.items) do
					processItem(item.id, item.name, cat, group.color)
					if itemsCount > 250 then break end
				end
				if itemsCount > 250 then break end
			end
		else
			-- Filtered search
			if extraNodes then
				for _, catGroup in ipairs(extraNodes) do
					for _, item in ipairs(catGroup.items) do
						if item.name:lower():find(filterLower) or catGroup.category:lower():find(filterLower) then
							processItem(item.id, item.name, catGroup.category, catGroup.color or Color3.fromRGB(150, 170, 200))
						end
					end
				end
			end

			-- Search in registeredNodes, grouped by category
			local resultsByCategory = {}
			local categories = {}

			for key, _ in pairs(registeredNodes) do
				local displayName, category, color = getNodeInfo(key)
				if category == "NPC" and scriptType ~= "NPC" then
					continue
				end
				if key:lower():find(filterLower) or category:lower():find(filterLower) then
					if not resultsByCategory[category] then
						resultsByCategory[category] = {color = color, items = {}}
						table.insert(categories, category)
					end
					table.insert(resultsByCategory[category].items, {id = key, name = displayName})
				end
			end
			table.sort(categories)

			for _, cat in ipairs(categories) do
				local group = resultsByCategory[cat]
				for _, item in ipairs(group.items) do
					processItem(item.id, item.name, cat, group.color)
					if itemsCount > 100 then break end
				end
				if itemsCount > 100 then break end
			end
		end

		-- Apply dynamic width (clamped for UX)
		local targetWidth = math.clamp(maxContentWidth + 20, 320, parent.AbsoluteSize.X - 40)
		menu.Size = UDim2.new(0, targetWidth, 0, 450)
		
		-- Re-center/adjust position if it overflowed after resizing
		local finalX = math.min(position.X, parent.AbsoluteSize.X - targetWidth)
		menu.Position = UDim2.fromOffset(finalX, menu.Position.Y.Offset)

		scroll.CanvasSize = UDim2.new(0, 0, 0, itemsCount * 40)
	end

	searchInput:GetPropertyChangedSignal("Text"):Connect(function()
		updateList(searchInput.Text)
	end)

	-- Initial display
	updateList("")
end

return NodeMenu
