-- Modal : a centered popup dialog over the widget
-- Usage:
--   Modal.prompt(parent, "Title", "Placeholder", function(text) ... end)

local Modal = {}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

-- Shows a modal dialog. Calls `onConfirm(text)` when OK is pressed, or does nothing on Cancel.
-- `parent` should be the widget (DockWidgetPluginGui).
function Modal.prompt(parent, title, placeholder, onConfirm)
	-- Overlay (darkens background)
	local overlay = Instance.new("TextButton")
	overlay.Name = "ModalOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.ZIndex = 10
	overlay.Parent = parent

	-- Dialog box
	local dialog = Instance.new("Frame")
	dialog.Name = "ModalDialog"
	dialog.Size = UDim2.new(0, 280, 0, 150)
	dialog.Position = UDim2.new(0.5, -140, 0.5, -75)
	dialog.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 11
	dialog.Parent = parent
	makeCorner(dialog, 8)

	-- Border stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 70, 110)
	stroke.Thickness = 1
	stroke.Parent = dialog

	-- Title label
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 30)
	titleLabel.Position = UDim2.new(0, 0, 0, 12)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = title
	titleLabel.TextColor3 = Color3.fromRGB(190, 210, 240)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.ZIndex = 12
	titleLabel.Parent = dialog

	-- TextBox
	local input = Instance.new("TextBox")
	input.Size = UDim2.new(1, -32, 0, 30)
	input.Position = UDim2.new(0, 16, 0, 50)
	input.BackgroundColor3 = Color3.fromRGB(14, 19, 30)
	input.BorderSizePixel = 0
	input.Text = ""
	input.PlaceholderText = placeholder
	input.PlaceholderColor3 = Color3.fromRGB(70, 85, 110)
	input.TextColor3 = Color3.fromRGB(200, 215, 240)
	input.TextSize = 13
	input.Font = Enum.Font.Gotham
	input.ClearTextOnFocus = false
	input.ZIndex = 12
	input.Parent = dialog
	makeCorner(input, 4)

	-- Button row
	local function makeBtn(name, label, pos, bg, fg)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = UDim2.new(0, 100, 0, 28)
		btn.Position = pos
		btn.BackgroundColor3 = bg
		btn.BorderSizePixel = 0
		btn.Text = label
		btn.TextColor3 = fg
		btn.TextSize = 12
		btn.Font = Enum.Font.GothamMedium
		btn.AutoButtonColor = true
		btn.ZIndex = 12
		btn.Parent = dialog
		makeCorner(btn, 4)
		return btn
	end

	local cancelBtn = makeBtn("Cancel", "Cancel",
		UDim2.new(0.5, -108, 1, -42),
		Color3.fromRGB(45, 30, 30), Color3.fromRGB(200, 120, 120))

	local okBtn = makeBtn("OK", "OK",
		UDim2.new(0.5, 8, 1, -42),
		Color3.fromRGB(28, 55, 95), Color3.fromRGB(110, 175, 240))

	local function close()
		overlay:Destroy()
		dialog:Destroy()
	end

	cancelBtn.MouseButton1Click:Connect(close)

	okBtn.MouseButton1Click:Connect(function()
		local text = input.Text
		if text and text ~= "" then
			close()
			onConfirm(text)
		end
	end)

	-- Also confirm on Enter key
	input.FocusLost:Connect(function(enterPressed)
		if enterPressed then
			local text = input.Text
			if text and text ~= "" then
				close()
				onConfirm(text)
			end
		end
	end)

	-- Focus the input immediately
	task.defer(function()
		input:CaptureFocus()
	end)
end

return Modal