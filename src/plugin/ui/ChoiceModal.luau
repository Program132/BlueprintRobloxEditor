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

function ChoiceModal.prompt(parent, title, choices, onConfirm)
	-- Overlay
	local overlay = Instance.new("TextButton")
	overlay.Name = "ChoiceModalOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.ZIndex = 30
	overlay.Parent = parent

	-- Dialog box
	local dialog = Instance.new("Frame")
	dialog.Name = "ChoiceModalDialog"
	local height = 80 + (#choices * 40)
	dialog.Size = UDim2.new(0, 240, 0, height)
	dialog.Position = UDim2.new(0.5, -120, 0.5, -height/2)
	dialog.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 31
	dialog.Parent = parent
	makeCorner(dialog, 8)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 70, 110)
	stroke.Thickness = 1
	stroke.Parent = dialog

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(190, 210, 240)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamMedium
	titleLabel.ZIndex = 32
	titleLabel.Parent = dialog

	local function close()
		overlay:Destroy()
		dialog:Destroy()
	end

	overlay.MouseButton1Click:Connect(close)

	-- Choice Buttons
	for i, choice in ipairs(choices) do
		local btn = Instance.new("TextButton")
		btn.Name = "Choice_" .. choice
		btn.Size = UDim2.new(1, -32, 0, 32)
		btn.Position = UDim2.new(0, 16, 0, 50 + (i-1) * 40)
		btn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
		btn.BorderSizePixel = 0
		btn.Text = choice
		btn.TextColor3 = Color3.fromRGB(180, 200, 230)
		btn.TextSize = 13
		btn.Font = Enum.Font.GothamMedium
		btn.AutoButtonColor = true
		btn.ZIndex = 32
		btn.Parent = dialog
		makeCorner(btn, 4)

		btn.MouseButton1Click:Connect(function()
			close()
			onConfirm(choice)
		end)
	end
end

return ChoiceModal
