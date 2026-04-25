-- ChoiceModal : a simple modal with multiple buttons for making a choice
-- Usage:
--   ChoiceModal.prompt(parent, "Title", {"Choice 1", "Choice 2"}, function(choice) ... end)

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
	overlay.BackgroundTransparency = isDropdown and 1 or 0.5
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.ZIndex = 30
	overlay.Parent = parent

	-- Dialog box
	local dialog = Instance.new("Frame")
	dialog.Name = "ChoiceModalDialog"
	
	if isDropdown then
		dialog.Size = UDim2.new(0, 200, 0, 300)
		dialog.Position = UDim2.fromOffset(targetPos.X, targetPos.Y)
	else
		local height = 80 + (#choices * 40)
		dialog.Size = UDim2.new(0, 240, 0, math.min(height, 400))
		dialog.Position = UDim2.new(0.5, -120, 0.5, -dialog.Size.Y.Offset/2)
	end
	
	dialog.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 31
	dialog.Parent = parent
	makeCorner(dialog, 8)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 70, 110)
	stroke.Thickness = 1
	stroke.Parent = dialog

	-- Scrolling Container
	local scroll = Instance.new("ScrollingFrame")
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Color3.fromRGB(80, 100, 140)
	scroll.ZIndex = 32
	scroll.Parent = dialog

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 2)
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
		titleLabel.TextColor3 = Color3.fromRGB(190, 210, 240)
		titleLabel.TextSize = 14
		titleLabel.Font = Enum.Font.GothamMedium
		titleLabel.ZIndex = 32
		titleLabel.Parent = dialog
		
		scroll.Size = UDim2.new(1, -20, 1, -50)
		scroll.Position = UDim2.new(0, 10, 0, 45)
	else
		-- Search Bar (only for dropdown)
		searchInput = Instance.new("TextBox")
		searchInput.Size = UDim2.new(1, -10, 0, 28)
		searchInput.Position = UDim2.new(0, 5, 0, 5)
		searchInput.BackgroundColor3 = Color3.fromRGB(15, 20, 30)
		searchInput.BorderSizePixel = 0
		searchInput.Text = ""
		searchInput.PlaceholderText = "Search..."
		searchInput.TextColor3 = Color3.fromRGB(200, 220, 255)
		searchInput.PlaceholderColor3 = Color3.fromRGB(100, 120, 150)
		searchInput.TextSize = 12
		searchInput.Font = Enum.Font.Gotham
		searchInput.ZIndex = 32
		searchInput.Parent = dialog
		makeCorner(searchInput, 4)
		
		scroll.Size = UDim2.new(1, -6, 1, -45)
		scroll.Position = UDim2.new(0, 3, 0, 40)
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
				btn.Size = UDim2.new(1, -8, 0, 24)
				btn.BackgroundColor3 = Color3.fromRGB(40, 50, 70)
				btn.BorderSizePixel = 0
				btn.Text = " " .. choice
				btn.TextColor3 = Color3.fromRGB(200, 220, 240)
				btn.TextSize = 11
				btn.Font = Enum.Font.Gotham
				btn.TextXAlignment = Enum.TextXAlignment.Left
				btn.AutoButtonColor = true
				btn.ZIndex = 33
				btn.Parent = scroll
				makeCorner(btn, 3)

				btn.MouseButton1Click:Connect(function()
					close()
					onConfirm(choice)
				end)
			end
		end
		scroll.CanvasSize = UDim2.new(0, 0, 0, count * 26)
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
