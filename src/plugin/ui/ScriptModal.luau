-- ScriptModal : a complex modal for creating/editing script configurations

local ScriptModal = {
	_renderDynamic = nil
}

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
	input.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	input.BorderSizePixel = 0
	input.Text = text or ""
	input.PlaceholderText = placeholder
	input.PlaceholderColor3 = Color3.fromRGB(70, 85, 110)
	input.TextColor3 = Color3.fromRGB(210, 225, 250)
	input.TextSize = 12
	input.Font = Enum.Font.Gotham
	input.ClearTextOnFocus = false
	input.Parent = parent
	makeCorner(input, 6)
	
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(40, 50, 75)
	stroke.Thickness = 1
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = input
	
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
	makeCorner(btn, 6)
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
		actions = scriptData and scriptData.actions or {},
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
	dialog.Size = UDim2.new(0, 380, 0, 460)
	dialog.Position = UDim2.new(0.5, -190, 0.5, -230)
	dialog.BackgroundColor3 = Color3.fromRGB(20, 26, 40)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 21
	dialog.Parent = parent
	makeCorner(dialog, 10)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(60, 80, 130)
	stroke.Thickness = 1.5
	stroke.Parent = dialog

	-- Title
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.Position = UDim2.new(0, 0, 0, 8)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = scriptData and "Edit Script" or "New Script"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 16
	titleLabel.Font = Enum.Font.GothamBold
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
		local btn = makeButton(typeContainer, typeName, UDim2.new(0, 80, 1, 0), UDim2.new(), Color3.fromRGB(30, 40, 60), Color3.fromRGB(130, 150, 180))
		btn.ZIndex = 22
		btn.MouseButton1Click:Connect(function()
			data.type = typeName
			updateTypeSelection()
			if ScriptModal._renderDynamic then
				ScriptModal._renderDynamic()
			end
		end)
		typeBtns[typeName] = btn
	end

	addTypeBtn("Default")
	addTypeBtn("Function")
	addTypeBtn("Module")
	addTypeBtn("Tool")
	updateTypeSelection()

	-- Dynamic content area (Scrollable)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -32, 1, -210)
	scroll.Position = UDim2.new(0, 16, 0, 135)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 3
	scroll.ScrollBarImageColor3 = Color3.fromRGB(70, 90, 130)
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

	local function promptMethodParams(method)
		local subOverlay = Instance.new("TextButton")
		subOverlay.Name = "SubOverlay"
		subOverlay.Size = UDim2.new(1, 0, 1, 0)
		subOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		subOverlay.BackgroundTransparency = 0.7
		subOverlay.BorderSizePixel = 0
		subOverlay.Text = ""
		subOverlay.AutoButtonColor = false
		subOverlay.ZIndex = 40
		subOverlay.Parent = overlay.Parent

		local subDialog = Instance.new("Frame")
		subDialog.Name = "SubDialog"
		subDialog.Size = UDim2.new(0, 320, 0, 400)
		subDialog.Position = UDim2.new(0.5, -160, 0.5, -200)
		subDialog.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
		subDialog.BorderSizePixel = 0
		subDialog.ZIndex = 41
		subDialog.Parent = subOverlay
		makeCorner(subDialog, 10)
		
		local subStroke = Instance.new("UIStroke")
		subStroke.Color = Color3.fromRGB(60, 80, 130)
		subStroke.Thickness = 1.5
		subStroke.Parent = subDialog
		
		local sLabel = Instance.new("TextLabel")
		sLabel.Size = UDim2.new(1, 0, 0, 50)
		sLabel.BackgroundTransparency = 1
		sLabel.Text = "Parameters: " .. method.name
		sLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
		sLabel.TextSize = 15
		sLabel.Font = Enum.Font.GothamBold
		sLabel.ZIndex = 42
		sLabel.Parent = subDialog

		local subScroll = Instance.new("ScrollingFrame")
		subScroll.Size = UDim2.new(1, -32, 1, -120)
		subScroll.Position = UDim2.new(0, 16, 0, 55)
		subScroll.BackgroundTransparency = 1
		subScroll.BorderSizePixel = 0
		subScroll.ScrollBarThickness = 3
		subScroll.ScrollBarImageColor3 = Color3.fromRGB(70, 90, 130)
		subScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
		subScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
		subScroll.ZIndex = 42
		subScroll.Parent = subDialog
		
		local subLayout = Instance.new("UIListLayout")
		subLayout.Padding = UDim.new(0, 10)
		subLayout.SortOrder = Enum.SortOrder.LayoutOrder
		subLayout.Parent = subScroll

		local order = 0
		local function renderSubList(title, list)
			local hFrame = Instance.new("Frame")
			hFrame.Size = UDim2.new(1, 0, 0, 25)
			hFrame.BackgroundTransparency = 1
			hFrame.LayoutOrder = order
			hFrame.Parent = subScroll
			order += 1

			local h = Instance.new("TextLabel")
			h.Size = UDim2.new(1, 0, 1, 0)
			h.BackgroundTransparency = 1
			h.Text = title:upper()
			h.TextColor3 = Color3.fromRGB(110, 140, 200)
			h.TextSize = 10
			h.Font = Enum.Font.GothamBold
			h.TextXAlignment = Enum.TextXAlignment.Left
			h.Parent = hFrame

			local line = Instance.new("Frame")
			line.Size = UDim2.new(1, 0, 0, 1)
			line.Position = UDim2.new(0, 0, 1, -2)
			line.BackgroundColor3 = Color3.fromRGB(45, 60, 95)
			line.BorderSizePixel = 0
			line.Parent = hFrame

			for i, it in ipairs(list) do
				local r = Instance.new("Frame")
				r.Size = UDim2.new(1, 0, 0, 32)
				r.BackgroundTransparency = 1
				r.LayoutOrder = order
				r.Parent = subScroll
				order += 1

				local inp = makeTextInput(r, "Name", it.name, UDim2.new(1, -34, 1, 0), UDim2.new(0, 0, 0, 0))
				inp.FocusLost:Connect(function() it.name = inp.Text end)

				local d = makeButton(r, "✕", UDim2.new(0, 26, 0, 26), UDim2.new(1, -26, 0.5, -13), Color3.fromRGB(70, 30, 30), Color3.fromRGB(255, 120, 120))
				d.Font = Enum.Font.GothamBold
				d.TextSize = 14
				d.MouseButton1Click:Connect(function()
					table.remove(list, i)
					subOverlay:Destroy()
					promptMethodParams(method)
				end)
			end
			
			local add = makeButton(subScroll, "+ Add " .. title:sub(1, -2), UDim2.new(1, 0, 0, 28), UDim2.new(), Color3.fromRGB(35, 48, 80), Color3.fromRGB(160, 190, 255))
			add.LayoutOrder = order
			add.Parent = subScroll
			order += 1
			
			local addStroke = Instance.new("UIStroke")
			addStroke.Color = Color3.fromRGB(55, 75, 120)
			addStroke.Thickness = 1
			addStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			addStroke.Parent = add

			add.MouseButton1Click:Connect(function()
				table.insert(list, {name = "new_" .. title:sub(1, -2):lower()})
				subOverlay:Destroy()
				promptMethodParams(method)
			end)
			
			-- Spacer
			local s = Instance.new("Frame")
			s.Size = UDim2.new(1, 0, 0, 8)
			s.BackgroundTransparency = 1
			s.LayoutOrder = order
			s.Parent = subScroll
			order += 1
		end

		method.inputs = method.inputs or {}
		method.outputs = method.outputs or {}

		renderSubList("Inputs", method.inputs)
		renderSubList("Outputs", method.outputs)

		local doneBtn = makeButton(subDialog, "Done", UDim2.new(0, 100, 0, 32), UDim2.new(0.5, -50, 1, -50), Color3.fromRGB(45, 85, 155), Color3.fromRGB(255, 255, 255))
		doneBtn.ZIndex = 42
		doneBtn.MouseButton1Click:Connect(function() subOverlay:Destroy() end)
	end

	local function makeListSection(title, listData, hasParams)
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

		local header = Instance.new("Frame")
		header.Size = UDim2.new(1, 0, 0, 28)
		header.BackgroundTransparency = 1
		header.ZIndex = 22
		header.Parent = section

		local hLabel = Instance.new("TextLabel")
		hLabel.Size = UDim2.new(1, -30, 1, 0)
		hLabel.BackgroundTransparency = 1
		hLabel.Text = title:upper()
		hLabel.TextColor3 = Color3.fromRGB(130, 150, 200)
		hLabel.TextSize = 10
		hLabel.Font = Enum.Font.GothamBold
		hLabel.TextXAlignment = Enum.TextXAlignment.Left
		hLabel.ZIndex = 22
		hLabel.Parent = header
		
		local hLine = Instance.new("Frame")
		hLine.Size = UDim2.new(1, 0, 0, 1)
		hLine.Position = UDim2.new(0, 0, 1, -2)
		hLine.BackgroundColor3 = Color3.fromRGB(45, 60, 90)
		hLine.BorderSizePixel = 0
		hLine.Parent = header

		local addBtn = makeButton(header, "+", UDim2.new(0, 24, 0, 24), UDim2.new(1, -24, 0, 0), Color3.fromRGB(40, 55, 90), Color3.fromRGB(180, 210, 255))
		addBtn.ZIndex = 22
		addBtn.MouseButton1Click:Connect(function()
			table.insert(listData, {name = "New", inputs = {}, outputs = {}})
			if ScriptModal._renderDynamic then ScriptModal._renderDynamic() end
		end)

		for i, item in ipairs(listData) do
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, 0, 0, 28)
			row.BackgroundTransparency = 1
			row.ZIndex = 22
			row.Parent = section

			local offset = hasParams and 64 or 34
			local nameBox = makeTextInput(row, "Name", item.name, UDim2.new(1, -offset, 1, 0), UDim2.new(0, 0, 0, 0))
			nameBox.ZIndex = 22
			nameBox.FocusLost:Connect(function() item.name = nameBox.Text end)

			if hasParams then
				local paramBtn = makeButton(row, "...", UDim2.new(0, 24, 0, 24), UDim2.new(1, -54, 0, 2), Color3.fromRGB(45, 100, 180), Color3.fromRGB(240, 240, 240))
				paramBtn.ZIndex = 23 -- Higher ZIndex to be sure
				paramBtn.MouseButton1Click:Connect(function()
					promptMethodParams(item)
				end)
			end

			local delBtn = makeButton(row, "X", UDim2.new(0, 24, 0, 24), UDim2.new(1, -24, 0, 2), Color3.fromRGB(90, 25, 25), Color3.fromRGB(230, 80, 80))
			delBtn.ZIndex = 22
			delBtn.MouseButton1Click:Connect(function()
				table.remove(listData, i)
				if ScriptModal._renderDynamic then ScriptModal._renderDynamic() end
			end)
		end
	end

	local function makeActionsSection(title, listData)
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

		local header = Instance.new("Frame")
		header.Size = UDim2.new(1, 0, 0, 28)
		header.BackgroundTransparency = 1
		header.ZIndex = 22
		header.Parent = section

		local hLabel = Instance.new("TextLabel")
		hLabel.Size = UDim2.new(1, -30, 1, 0)
		hLabel.BackgroundTransparency = 1
		hLabel.Text = title:upper()
		hLabel.TextColor3 = Color3.fromRGB(130, 150, 200)
		hLabel.TextSize = 10
		hLabel.Font = Enum.Font.GothamBold
		hLabel.TextXAlignment = Enum.TextXAlignment.Left
		hLabel.ZIndex = 22
		hLabel.Parent = header
		
		local hLine = Instance.new("Frame")
		hLine.Size = UDim2.new(1, 0, 0, 1)
		hLine.Position = UDim2.new(0, 0, 1, -2)
		hLine.BackgroundColor3 = Color3.fromRGB(45, 60, 90)
		hLine.BorderSizePixel = 0
		hLine.Parent = header

		local addBtn = makeButton(header, "+", UDim2.new(0, 24, 0, 24), UDim2.new(1, -24, 0, 0), Color3.fromRGB(40, 55, 90), Color3.fromRGB(180, 210, 255))
		addBtn.ZIndex = 22
		addBtn.MouseButton1Click:Connect(function()
			table.insert(listData, {name = "Action", key = "E"})
			if ScriptModal._renderDynamic then ScriptModal._renderDynamic() end
		end)

		-- Gather KeyCodes list
		local keyCodes = {}
		for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do
			table.insert(keyCodes, item.Name)
		end
		table.sort(keyCodes)

		for i, item in ipairs(listData) do
			local row = Instance.new("Frame")
			row.Size = UDim2.new(1, 0, 0, 28)
			row.BackgroundTransparency = 1
			row.ZIndex = 22
			row.Parent = section

			-- Name box (takes 48% of width)
			local nameBox = makeTextInput(row, "Action Name...", item.name, UDim2.new(0.48, 0, 1, 0), UDim2.new(0, 0, 0, 0))
			nameBox.ZIndex = 22
			nameBox.FocusLost:Connect(function() 
				-- Replace spaces and non-alphanumeric chars to keep Luau identifier valid
				local safeName = nameBox.Text:gsub("%s+", ""):gsub("[^%w_]", "")
				item.name = safeName ~= "" and safeName or "Action"
				nameBox.Text = item.name
			end)

			-- Choice button for Key (takes 38% of width)
			local choiceBtn = makeButton(row, item.key or "E", UDim2.new(0.38, 0, 1, 0), UDim2.new(0.5, 0, 0, 0), Color3.fromRGB(30, 40, 60), Color3.fromRGB(200, 220, 255))
			choiceBtn.ZIndex = 23
			
			local choiceStroke = Instance.new("UIStroke")
			choiceStroke.Color = Color3.fromRGB(50, 65, 90)
			choiceStroke.Thickness = 1
			choiceStroke.Parent = choiceBtn

			choiceBtn.MouseButton1Click:Connect(function()
				local topContainer = dialog:FindFirstAncestorWhichIsA("LayerCollector") or dialog
				local ChoiceModal = require(script.Parent.ChoiceModal)
				ChoiceModal.prompt(topContainer, "Select KeyCode", keyCodes, function(choice)
					item.key = choice
					choiceBtn.Text = choice
				end)
			end)

			-- Delete button
			local delBtn = makeButton(row, "✕", UDim2.new(0, 24, 0, 24), UDim2.new(1, -24, 0, 0), Color3.fromRGB(90, 25, 25), Color3.fromRGB(230, 80, 80))
			delBtn.ZIndex = 22
			delBtn.MouseButton1Click:Connect(function()
				table.remove(listData, i)
				if ScriptModal._renderDynamic then ScriptModal._renderDynamic() end
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
			makeListSection("Methods", data.methods, true)
		elseif data.type == "Tool" then
			data.actions = data.actions or {}
			makeActionsSection("Actions", data.actions)
		end
	end

	ScriptModal._renderDynamic()

	-- Bottom Buttons
	local cancelBtn = makeButton(dialog, "Cancel", UDim2.new(0, 110, 0, 32), UDim2.new(0.5, -118, 1, -50), Color3.fromRGB(60, 35, 35), Color3.fromRGB(255, 150, 150))
	cancelBtn.ZIndex = 22
	
	local okBtn = makeButton(dialog, "Save", UDim2.new(0, 110, 0, 32), UDim2.new(0.5, 8, 1, -50), Color3.fromRGB(45, 90, 165), Color3.fromRGB(255, 255, 255))
	okBtn.ZIndex = 22

	local function close()
		overlay:Destroy()
		dialog:Destroy()
		ScriptModal._renderDynamic = nil
	end

	cancelBtn.MouseButton1Click:Connect(close)

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
