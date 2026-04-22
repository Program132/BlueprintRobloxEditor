-- ScriptModal : a complex modal for creating/editing script configurations

local ScriptModal = {}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

-- Helper to create a simple input text field
local function makeTextInput(parent, placeholder, text, size, pos)
	local input = Instance.new("TextBox")
	input.Size = size
	input.Position = pos
	input.BackgroundColor3 = Color3.fromRGB(14, 19, 30)
	input.BorderSizePixel = 0
	input.Text = text or ""
	input.PlaceholderText = placeholder
	input.PlaceholderColor3 = Color3.fromRGB(70, 85, 110)
	input.TextColor3 = Color3.fromRGB(200, 215, 240)
	input.TextSize = 12
	input.Font = Enum.Font.Gotham
	input.ClearTextOnFocus = false
	input.Parent = parent
	makeCorner(input, 4)
	return input
end

local function makeButton(parent, label, size, pos, bg, fg)
	local btn = Instance.new("TextButton")
	btn.Size = size
	btn.Position = pos
	btn.BackgroundColor3 = bg
	btn.BorderSizePixel = 0
	btn.Text = label
	btn.TextColor3 = fg
	btn.TextSize = 12
	btn.Font = Enum.Font.GothamMedium
	btn.AutoButtonColor = true
	btn.Parent = parent
	makeCorner(btn, 4)
	return btn
end

-- scriptData is optional. If passed, it edits an existing script.
function ScriptModal.prompt(parent, scriptData, onConfirm)
	local data = {
		name = scriptData and scriptData.name or "",
		type = scriptData and scriptData.type or "Default",
		inputs = scriptData and scriptData.inputs or {},
		outputs = scriptData and scriptData.outputs or {},
		attributes = scriptData and scriptData.attributes or {},
		methods = scriptData and scriptData.methods or {},
		graph = scriptData and scriptData.graph or nil, -- Preserve graph!
	}

	-- Create overlay
	local overlay = Instance.new("TextButton")
	overlay.Name = "ScriptModalOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.ZIndex = 20
	overlay.Parent = parent

	-- Main dialog
	local dialog = Instance.new("Frame")
	dialog.Name = "ScriptModalDialog"
	dialog.Size = UDim2.new(0, 360, 0, 420)
	dialog.Position = UDim2.new(0.5, -180, 0.5, -210)
	dialog.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 21
	dialog.Parent = parent
	makeCorner(dialog, 8)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 70, 110)
	stroke.Thickness = 1
	stroke.Parent = dialog

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 30)
	titleLabel.Position = UDim2.new(0, 0, 0, 12)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = scriptData and "Edit Script" or "New Script"
	titleLabel.TextColor3 = Color3.fromRGB(190, 210, 240)
	titleLabel.TextSize = 14
	titleLabel.Font = Enum.Font.GothamSemibold
	titleLabel.ZIndex = 22
	titleLabel.Parent = dialog

	-- Name input
	local nameInput = makeTextInput(dialog, "Script Name...", data.name, UDim2.new(1, -32, 0, 30), UDim2.new(0, 16, 0, 50))
	nameInput.ZIndex = 22

	-- Type selector
	local typeContainer = Instance.new("Frame")
	typeContainer.Size = UDim2.new(1, -32, 0, 30)
	typeContainer.Position = UDim2.new(0, 16, 0, 90)
	typeContainer.BackgroundTransparency = 1
	typeContainer.ZIndex = 22
	typeContainer.Parent = dialog

	local typeLayout = Instance.new("UIListLayout")
	typeLayout.FillDirection = Enum.FillDirection.Horizontal
	typeLayout.Padding = UDim.new(0, 8)
	typeLayout.Parent = typeContainer

	local typeBtns = {}
	local function updateTypeSelection()
		for t, btn in typeBtns do
			if t == data.type then
				btn.BackgroundColor3 = Color3.fromRGB(45, 85, 145)
				btn.TextColor3 = Color3.fromRGB(240, 240, 240)
			else
				btn.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
				btn.TextColor3 = Color3.fromRGB(130, 150, 180)
			end
		end
	end

	local function addTypeBtn(typeName)
		local btn = makeButton(typeContainer, typeName, UDim2.new(0, 100, 1, 0), UDim2.new(), Color3.fromRGB(30, 40, 60), Color3.fromRGB(130, 150, 180))
		btn.ZIndex = 22
		btn.MouseButton1Click:Connect(function()
			data.type = typeName
			updateTypeSelection()
			-- We will re-render the dynamic content
			if ScriptModal._renderDynamic then
				ScriptModal._renderDynamic()
			end
		end)
		typeBtns[typeName] = btn
	end

	addTypeBtn("Default")
	addTypeBtn("Function")
	addTypeBtn("Module")
	updateTypeSelection()

	-- Dynamic content area (Scrollable)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -32, 1, -180)
	scroll.Position = UDim2.new(0, 16, 0, 130)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Color3.fromRGB(50, 65, 95)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.ZIndex = 22
	scroll.Parent = dialog

	local scrollLayout = Instance.new("UIListLayout")
	scrollLayout.FillDirection = Enum.FillDirection.Vertical
	scrollLayout.Padding = UDim.new(0, 12)
	scrollLayout.Parent = scroll

	local function clearScroll()
		for _, child in scroll:GetChildren() do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
	end

	local function makeListSection(title, listData)
		local section = Instance.new("Frame")
		section.Size = UDim2.new(1, 0, 0, 0)
		section.BackgroundTransparency = 1
		section.AutomaticSize = Enum.AutomaticSize.Y
		section.ZIndex = 22
		section.Parent = scroll

		local slayout = Instance.new("UIListLayout")
		slayout.FillDirection = Enum.FillDirection.Vertical
		slayout.Padding = UDim.new(0, 6)
		slayout.Parent = section

		-- Header
		local header = Instance.new("Frame")
		header.Size = UDim2.new(1, 0, 0, 24)
		header.BackgroundTransparency = 1
		header.ZIndex = 22
		header.Parent = section

		local hLabel = Instance.new("TextLabel")
		hLabel.Size = UDim2.new(1, -30, 1, 0)
		hLabel.BackgroundTransparency = 1
		hLabel.Text = title
		hLabel.TextColor3 = Color3.fromRGB(160, 180, 210)
		hLabel.TextSize = 12
		hLabel.Font = Enum.Font.GothamMedium
		hLabel.TextXAlignment = Enum.TextXAlignment.Left
		hLabel.ZIndex = 22
		hLabel.Parent = header

		local addBtn = makeButton(header, "+", UDim2.new(0, 24, 0, 24), UDim2.new(1, -24, 0, 0), Color3.fromRGB(38, 52, 82), Color3.fromRGB(110, 155, 230))
		addBtn.ZIndex = 22
		addBtn.MouseButton1Click:Connect(function()
			table.insert(listData, {name = "New"})
			ScriptModal._renderDynamic()
		end)

		-- Items
		for i, item in ipairs(listData) do
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, 0, 0, 28)
			row.BackgroundTransparency = 1
			row.ZIndex = 22
			row.Parent = section

			local nameBox = makeTextInput(row, "Name", item.name, UDim2.new(1, -34, 1, 0), UDim2.new(0, 0, 0, 0))
			nameBox.ZIndex = 22
			nameBox.FocusLost:Connect(function() item.name = nameBox.Text end)

			local delBtn = makeButton(row, "X", UDim2.new(0, 24, 0, 24), UDim2.new(1, -24, 0, 2), Color3.fromRGB(90, 25, 25), Color3.fromRGB(230, 80, 80))
			delBtn.ZIndex = 22
			delBtn.MouseButton1Click:Connect(function()
				table.remove(listData, i)
				ScriptModal._renderDynamic()
			end)
		end
	end

	ScriptModal._renderDynamic = function()
		clearScroll()
		if data.type == "Function" then
			makeListSection("Inputs", data.inputs)
			makeListSection("Outputs (Returns)", data.outputs)
		elseif data.type == "Module" then
			makeListSection("Attributes (Variables)", data.attributes)
			makeListSection("Methods", data.methods)
		end
	end

	ScriptModal._renderDynamic()

	-- Bottom Buttons
	local cancelBtn = makeButton(dialog, "Cancel", UDim2.new(0, 100, 0, 28), UDim2.new(0.5, -108, 1, -42), Color3.fromRGB(45, 30, 30), Color3.fromRGB(200, 120, 120))
	cancelBtn.ZIndex = 22
	
	local okBtn = makeButton(dialog, "Save", UDim2.new(0, 100, 0, 28), UDim2.new(0.5, 8, 1, -42), Color3.fromRGB(28, 55, 95), Color3.fromRGB(110, 175, 240))
	okBtn.ZIndex = 22

	local function close()
		overlay:Destroy()
		dialog:Destroy()
		ScriptModal._renderDynamic = nil
	end

	cancelBtn.MouseButton1Click:Connect(close)
	overlay.MouseButton1Click:Connect(close)

	okBtn.MouseButton1Click:Connect(function()
		data.name = nameInput.Text
		if data.name and data.name ~= "" then
			close()
			onConfirm(data)
		end
	end)

	task.defer(function()
		nameInput:CaptureFocus()
	end)
end

return ScriptModal
