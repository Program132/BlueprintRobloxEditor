local ChoiceModal = {}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

function ChoiceModal.prompt(parent, title, choices, onConfirm, targetPos)
	local isDropdown = targetPos ~= nil
	
	-- Overlay
	local overlay = Instance.new("TextButton")
	overlay.Name = "ChoiceModalOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundTransparency = 1
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.ZIndex = 30
	overlay.Parent = parent

	-- Dialog box
	local dialog = Instance.new("Frame")
	dialog.Name = "ChoiceModalDialog"
	
	if isDropdown then
		dialog.Size = UDim2.new(0, 240, 0, 350)
		dialog.Position = UDim2.fromOffset(targetPos.X, targetPos.Y)
	else
		local height = 100 + (#choices * 36)
		dialog.Size = UDim2.new(0, 280, 0, math.min(height, 450))
		dialog.Position = UDim2.new(0.5, -140, 0.5, -dialog.Size.Y.Offset/2)
	end
	
	dialog.BackgroundColor3 = Color3.fromRGB(20, 25, 40)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 31
	dialog.Parent = parent
	makeCorner(dialog, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 70, 110)
	stroke.Thickness = 1.5
	stroke.Parent = dialog

	-- Gradient background (matching NodeMenu 45deg)
	local gradient = Instance.new("UIGradient")
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 30, 48)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 20, 32))
	})
	gradient.Rotation = 45
	gradient.Parent = dialog

	-- Scrolling Container
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "ResultsList"
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 5
	scroll.ScrollBarImageColor3 = Color3.fromRGB(60, 80, 120)
	scroll.ZIndex = 32
	scroll.Parent = dialog

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Parent = scroll

	local function close()
		overlay:Destroy()
		dialog:Destroy()
	end

	overlay.MouseButton1Click:Connect(close)

	local searchInput = nil
	if not isDropdown then
		-- Title (only for modal)
		local titleLabel = Instance.new("TextLabel")
		titleLabel.Size = UDim2.new(1, 0, 0, 40)
		titleLabel.BackgroundTransparency = 1
		titleLabel.Text = title
		titleLabel.TextColor3 = Color3.fromRGB(230, 240, 255)
		titleLabel.TextSize = 14
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.ZIndex = 32
		titleLabel.Parent = dialog
		
		scroll.Size = UDim2.new(1, -12, 1, -50)
		scroll.Position = UDim2.new(0, 6, 0, 45)
	else
		-- Search Bar Container
		local searchContainer = Instance.new("Frame")
		searchContainer.Name = "SearchContainer"
		searchContainer.Size = UDim2.new(1, -24, 0, 36)
		searchContainer.Position = UDim2.new(0, 12, 0, 12)
		searchContainer.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
		searchContainer.BorderSizePixel = 0
		searchContainer.ZIndex = 32
		searchContainer.Parent = dialog
		makeCorner(searchContainer, 8)

		local searchIcon = Instance.new("ImageLabel")
		searchIcon.Size = UDim2.new(0, 16, 0, 16)
		searchIcon.Position = UDim2.new(0, 10, 0.5, -8)
		searchIcon.BackgroundTransparency = 1
		searchIcon.Image = "rbxassetid://6031280260"
		searchIcon.ImageColor3 = Color3.fromRGB(100, 120, 160)
		searchIcon.ZIndex = 33
		searchIcon.Parent = searchContainer

		searchInput = Instance.new("TextBox")
		searchInput.Name = "SearchInput"
		searchInput.Size = UDim2.new(1, -40, 1, 0)
		searchInput.Position = UDim2.new(0, 32, 0, 0)
		searchInput.BackgroundTransparency = 1
		searchInput.Text = ""
		searchInput.PlaceholderText = "Search..."
		searchInput.TextColor3 = Color3.fromRGB(230, 240, 255)
		searchInput.PlaceholderColor3 = Color3.fromRGB(70, 90, 120)
		searchInput.TextSize = 13
		searchInput.Font = Enum.Font.Gotham
		searchInput.TextXAlignment = Enum.TextXAlignment.Left
		searchInput.ClearTextOnFocus = false
		searchInput.ZIndex = 33
		searchInput.Parent = searchContainer

		scroll.Size = UDim2.new(1, -12, 1, -62)
		scroll.Position = UDim2.new(0, 6, 0, 56)
	end

	local function updateList(filter)
		for _, child in ipairs(scroll:GetChildren()) do
			if child:IsA("TextButton") then child:Destroy() end
		end

		local count = 0
		for _, choice in ipairs(choices) do
			if filter == "" or choice:lower():find(filter:lower()) then
				count += 1
				local btn = Instance.new("TextButton")
				btn.Name = "Choice_" .. choice
				btn.Size = UDim2.new(1, -10, 0, 30)
				btn.BackgroundColor3 = Color3.fromRGB(32, 40, 58)
				btn.BorderSizePixel = 0
				btn.Text = "  " .. choice
				btn.TextColor3 = Color3.fromRGB(235, 245, 255)
				btn.TextSize = 12
				btn.Font = Enum.Font.GothamMedium
				btn.TextXAlignment = Enum.TextXAlignment.Left
				btn.AutoButtonColor = true
				btn.ZIndex = 33
				btn.Parent = scroll
				makeCorner(btn, 6)

				btn.MouseEnter:Connect(function()
					btn.BackgroundColor3 = Color3.fromRGB(55, 70, 110)
				end)
				btn.MouseLeave:Connect(function()
					btn.BackgroundColor3 = Color3.fromRGB(32, 40, 58)
				end)

				btn.MouseButton1Click:Connect(function()
					close()
					onConfirm(choice)
				end)
			end
		end
		scroll.CanvasSize = UDim2.new(0, 0, 0, count * 34)
	end

	if searchInput then
		searchInput:GetPropertyChangedSignal("Text"):Connect(function()
			updateList(searchInput.Text)
		end)
		searchInput:CaptureFocus()
	end

	updateList("")
end

return ChoiceModal
