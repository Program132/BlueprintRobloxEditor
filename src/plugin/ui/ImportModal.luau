-- ImportModal : a dialog popup to select scripts to import from another project file
-- Usage:
--   ImportModal.prompt(parent, scriptsList, function(selectedScripts) ... end)

local ImportModal = {}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

function ImportModal.prompt(parent, scriptsToImport, onConfirm)
	-- Overlay (darkens background)
	local overlay = Instance.new("TextButton")
	overlay.Name = "ImportModalOverlay"
	overlay.Size = UDim2.new(1, 0, 1, 0)
	overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	overlay.BackgroundTransparency = 0.5
	overlay.BorderSizePixel = 0
	overlay.Text = ""
	overlay.AutoButtonColor = false
	overlay.ZIndex = 100
	overlay.Parent = parent

	-- Dialog box
	local dialog = Instance.new("Frame")
	dialog.Name = "ImportModalDialog"
	dialog.Size = UDim2.new(0, 480, 0, 360)
	dialog.Position = UDim2.new(0.5, -240, 0.5, -180)
	dialog.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
	dialog.BorderSizePixel = 0
	dialog.ZIndex = 101
	dialog.Parent = parent
	makeCorner(dialog, 8)

	-- Border stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(50, 70, 110)
	stroke.Thickness = 1
	stroke.Parent = dialog

	-- Title label
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0.5, 0, 0, 30)
	titleLabel.Position = UDim2.new(0, 16, 0, 12)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "IMPORT SCRIPTS"
	titleLabel.TextColor3 = Color3.fromRGB(190, 210, 240)
	titleLabel.TextSize = 13
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.ZIndex = 102
	titleLabel.Parent = dialog

	-- Selection checkboxes state
	local selectedIndices = {}
	for i = 1, #scriptsToImport do
		selectedIndices[i] = true -- select all by default
	end

	local rows = {}

	-- Helper button maker
	local function makeTextBtn(name, label, size, pos, bg, fg)
		local btn = Instance.new("TextButton")
		btn.Name = name
		btn.Size = size
		btn.Position = pos
		btn.BackgroundColor3 = bg
		btn.BorderSizePixel = 0
		btn.Text = label
		btn.TextColor3 = fg
		btn.TextSize = 11
		btn.Font = Enum.Font.GothamMedium
		btn.AutoButtonColor = true
		btn.ZIndex = 102
		btn.Parent = dialog
		makeCorner(btn, 4)
		return btn
	end

	-- ScrollingFrame for scripts list
	local listScroll = Instance.new("ScrollingFrame")
	listScroll.Size = UDim2.new(1, -32, 1, -100)
	listScroll.Position = UDim2.new(0, 16, 0, 46)
	listScroll.BackgroundColor3 = Color3.fromRGB(14, 19, 30)
	listScroll.BorderSizePixel = 0
	listScroll.ScrollBarThickness = 4
	listScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 75, 110)
	listScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	listScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	listScroll.ZIndex = 102
	listScroll.Parent = dialog
	makeCorner(listScroll, 4)

	local listStroke = Instance.new("UIStroke")
	listStroke.Color = Color3.fromRGB(35, 45, 65)
	listStroke.Thickness = 1
	listStroke.Parent = listScroll

	local listLayout = Instance.new("UIListLayout")
	listLayout.Padding = UDim.new(0, 4)
	listLayout.Parent = listScroll

	local listPad = Instance.new("UIPadding")
	listPad.PaddingTop = UDim.new(0, 6)
	listPad.PaddingBottom = UDim.new(0, 6)
	listPad.PaddingLeft = UDim.new(0, 8)
	listPad.PaddingRight = UDim.new(0, 8)
	listPad.Parent = listScroll

	-- Render a script row
	local function updateRowVisual(i)
		local rData = rows[i]
		if not rData then return end
		local selected = selectedIndices[i]

		rData.checkbox.BackgroundColor3 = selected and Color3.fromRGB(35, 75, 125) or Color3.fromRGB(20, 25, 35)
		rData.checkbox.Text = selected and "v" or ""
		rData.rowFrame.BackgroundColor3 = selected and Color3.fromRGB(30, 36, 54) or Color3.fromRGB(22, 28, 45)
	end

	for i, s in ipairs(scriptsToImport) do
		local row = Instance.new("Frame")
		row.Name = "ImportRow_" .. i
		row.Size = UDim2.new(1, 0, 0, 30)
		row.BorderSizePixel = 0
		row.ZIndex = 103
		row.Parent = listScroll
		makeCorner(row, 4)

		local rowClick = Instance.new("TextButton")
		rowClick.Size = UDim2.new(1, 0, 1, 0)
		rowClick.BackgroundTransparency = 1
		rowClick.Text = ""
		rowClick.ZIndex = 104
		rowClick.Parent = row

		local nameLabel = Instance.new("TextLabel")
		nameLabel.Size = UDim2.new(0.5, -10, 1, 0)
		nameLabel.Position = UDim2.new(0, 10, 0, 0)
		nameLabel.BackgroundTransparency = 1
		nameLabel.Text = s.name or "Script"
		nameLabel.TextColor3 = Color3.fromRGB(170, 195, 230)
		nameLabel.TextSize = 12
		nameLabel.Font = Enum.Font.GothamMedium
		nameLabel.TextXAlignment = Enum.TextXAlignment.Left
		nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
		nameLabel.ZIndex = 104
		nameLabel.Parent = row

		-- Type Tag
		local typeStr = "DEF"
		local tagBg = Color3.fromRGB(30, 40, 60)
		local tagFg = Color3.fromRGB(110, 160, 240)

		if s.type == "Function" then
			typeStr = "FUN"
			tagBg = Color3.fromRGB(30, 60, 50)
			tagFg = Color3.fromRGB(90, 200, 150)
		elseif s.type == "Module" then
			typeStr = "MOD"
			tagBg = Color3.fromRGB(60, 30, 60)
			tagFg = Color3.fromRGB(200, 90, 200)
		elseif s.type == "Tool" then
			typeStr = "TOL"
			tagBg = Color3.fromRGB(80, 50, 20)
			tagFg = Color3.fromRGB(250, 160, 50)
		elseif s.type == "NPC" then
			typeStr = "NPC"
			tagBg = Color3.fromRGB(20, 60, 60)
			tagFg = Color3.fromRGB(50, 220, 220)
		elseif s.type == "UI" then
			typeStr = "UI "
			tagBg = Color3.fromRGB(45, 30, 80)
			tagFg = Color3.fromRGB(180, 120, 255)
		end

		local tag = Instance.new("TextLabel")
		tag.Size = UDim2.new(0, 32, 0, 18)
		tag.Position = UDim2.new(0.5, 0, 0.5, -9)
		tag.BackgroundColor3 = tagBg
		tag.BorderSizePixel = 0
		tag.Text = typeStr
		tag.TextColor3 = tagFg
		tag.TextSize = 9
		tag.Font = Enum.Font.GothamBold
		tag.ZIndex = 104
		tag.Parent = row
		makeCorner(tag, 3)

		-- Node count
		local nodeCount = 0
		if s.graph and typeof(s.graph) == "table" and s.graph.nodes and typeof(s.graph.nodes) == "table" then
			nodeCount = #s.graph.nodes
		end
		
		local countLabel = Instance.new("TextLabel")
		countLabel.Size = UDim2.new(0.3, -42, 1, 0)
		countLabel.Position = UDim2.new(0.5, 38, 0, 0)
		countLabel.BackgroundTransparency = 1
		countLabel.Text = nodeCount .. " nodes"
		countLabel.TextColor3 = Color3.fromRGB(100, 120, 150)
		countLabel.TextSize = 11
		countLabel.Font = Enum.Font.Gotham
		countLabel.TextXAlignment = Enum.TextXAlignment.Left
		countLabel.ZIndex = 104
		countLabel.Parent = row

		-- Checkbox
		local checkbox = Instance.new("TextButton")
		checkbox.Size = UDim2.fromOffset(18, 18)
		checkbox.Position = UDim2.new(1, -28, 0.5, -9)
		checkbox.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
		checkbox.BorderSizePixel = 0
		checkbox.Text = ""
		checkbox.TextColor3 = Color3.fromRGB(255, 255, 255)
		checkbox.TextSize = 11
		checkbox.Font = Enum.Font.GothamBold
		checkbox.ZIndex = 105
		checkbox.Parent = row
		makeCorner(checkbox, 4)

		local checkStroke = Instance.new("UIStroke")
		checkStroke.Color = Color3.fromRGB(50, 60, 80)
		checkStroke.Thickness = 1
		checkStroke.Parent = checkbox

		rows[i] = {
			rowFrame = row,
			checkbox = checkbox
		}

		local function toggle()
			selectedIndices[i] = not selectedIndices[i]
			updateRowVisual(i)
		end

		rowClick.MouseButton1Click:Connect(toggle)
		checkbox.MouseButton1Click:Connect(toggle)

		updateRowVisual(i)
	end

	-- Top control buttons
	local selectAllBtn = makeTextBtn("SelectAll", "Select All",
		UDim2.new(0, 80, 0, 22),
		UDim2.new(1, -188, 0, 12),
		Color3.fromRGB(38, 52, 82), Color3.fromRGB(110, 155, 230))

	local selectNoneBtn = makeTextBtn("SelectNone", "Clear",
		UDim2.new(0, 80, 0, 22),
		UDim2.new(1, -98, 0, 12),
		Color3.fromRGB(35, 40, 50), Color3.fromRGB(130, 145, 170))

	selectAllBtn.MouseButton1Click:Connect(function()
		for i = 1, #scriptsToImport do
			selectedIndices[i] = true
			updateRowVisual(i)
		end
	end)

	selectNoneBtn.MouseButton1Click:Connect(function()
		for i = 1, #scriptsToImport do
			selectedIndices[i] = false
			updateRowVisual(i)
		end
	end)

	local function close()
		overlay:Destroy()
		dialog:Destroy()
	end

	-- Cancel & Import Buttons
	local cancelBtn = makeTextBtn("Cancel", "Cancel",
		UDim2.new(0, 120, 0, 30),
		UDim2.new(0.5, -130, 1, -42),
		Color3.fromRGB(45, 30, 30), Color3.fromRGB(200, 120, 120))

	local confirmBtn = makeTextBtn("Confirm", "Confirm Import",
		UDim2.new(0, 120, 0, 30),
		UDim2.new(0.5, 10, 1, -42),
		Color3.fromRGB(28, 55, 95), Color3.fromRGB(110, 175, 240))

	cancelBtn.MouseButton1Click:Connect(close)

	confirmBtn.MouseButton1Click:Connect(function()
		local finalSelection = {}
		for i, s in ipairs(scriptsToImport) do
			if selectedIndices[i] then
				table.insert(finalSelection, s)
			end
		end
		
		close()
		
		if #finalSelection > 0 then
			onConfirm(finalSelection)
		end
	end)
end

return ImportModal
