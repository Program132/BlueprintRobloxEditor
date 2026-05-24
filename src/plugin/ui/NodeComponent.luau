local NodeComponent = {}
NodeComponent.__index = NodeComponent

local TextService = game:GetService("TextService")
local ChoiceModal = require(script.Parent.ChoiceModal)

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function makePin(parent, labelText, isOutput, isExec, choices, fieldWidth, dataType)
	local row = Instance.new("TextButton")
	row.Text = ""
	row.AutoButtonColor = false
	row.Size = UDim2.new(1, 0, 0, 24)
	row.BackgroundTransparency = 1
	row.Active = true -- Capture clicks on the whole row, sinking them!
	row.Parent = parent

	local pin = Instance.new("Frame")
	pin.Size = UDim2.new(0, 12, 0, 12)
	-- Shift pin inwards so it is fully inside the row bounds
	pin.Position = UDim2.new(isOutput and 1 or 0, isOutput and -12 or 0, 0.5, -6)
	pin.BackgroundColor3 = isExec and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(110, 180, 240)
	pin.BorderSizePixel = 0
	pin.ZIndex = 12
	pin.Active = false
	pin.Parent = row
	makeCorner(pin, 6)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	-- Shift label text slightly inwards to account for the pin
	label.Position = UDim2.new(isOutput and 0 or 0, isOutput and 0 or 15, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(200, 215, 230)
	label.TextSize = 11
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = isOutput and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
	label.ZIndex = 11
	label.Parent = row

	local typeLabel = nil
	if dataType and not isExec then
		typeLabel = Instance.new("TextLabel")
		typeLabel.Size = UDim2.new(1, 0, 1, 0)
		typeLabel.BackgroundTransparency = 1
		typeLabel.Text = "(" .. dataType .. ")"
		typeLabel.TextColor3 = Color3.fromRGB(140, 160, 180) -- Brighter
		typeLabel.TextSize = 9
		typeLabel.Font = Enum.Font.GothamMedium -- Bolder
		typeLabel.TextXAlignment = isOutput and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
		typeLabel.ZIndex = 11
		typeLabel.Parent = row
	end

	local inputField = nil
	local choiceButton = nil
	if not isOutput and not isExec then
		local actualFieldWidth = fieldWidth or 50
		if choices then
			choiceButton = Instance.new("TextButton")
			choiceButton.Size = UDim2.new(0, math.max(60, actualFieldWidth), 0, 18)
			choiceButton.Position = UDim2.new(0, 15, 0.5, -9)
			choiceButton.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
			choiceButton.BorderSizePixel = 0
			choiceButton.Text = "select"
			choiceButton.TextColor3 = Color3.fromRGB(200, 215, 240)
			choiceButton.TextSize = 10
			choiceButton.Font = Enum.Font.Gotham
			choiceButton.ZIndex = 13
			choiceButton.Parent = row
			makeCorner(choiceButton, 4)
			
			label.Position = UDim2.new(0, choiceButton.Size.X.Offset + 20, 0, 0)
			label.Size = UDim2.new(1, -choiceButton.Size.X.Offset - 25, 1, 0)
		else
			inputField = Instance.new("TextBox")
			inputField.Size = UDim2.new(0, actualFieldWidth, 0, 18)
			inputField.Position = UDim2.new(0, 15, 0.5, -9)
			inputField.BackgroundColor3 = Color3.fromRGB(14, 19, 30)
			inputField.BorderSizePixel = 0
			inputField.Text = ""
			inputField.PlaceholderText = "val"
			inputField.TextColor3 = Color3.fromRGB(200, 215, 240)
			inputField.TextSize = 10
			inputField.Font = Enum.Font.Gotham
			inputField.ClearTextOnFocus = false
			inputField.ZIndex = 13
			inputField.Parent = row
			makeCorner(inputField, 4)
			
			-- Shift label to the right of the input field
			label.Position = UDim2.new(0, actualFieldWidth + 20, 0, 0)
			label.Size = UDim2.new(1, -actualFieldWidth - 25, 1, 0)
		end
	end

	return { 
		row = row, 
		pin = pin, 
		inputField = inputField, 
		choiceButton = choiceButton, 
		label = label, 
		typeLabel = typeLabel,
		fieldWidth = if (not isOutput and not isExec) then (fieldWidth or 50) else 0 
	}
end

local TYPE_COLORS = {
	EVENT = Color3.fromRGB(150, 40, 40),
	METHOD = Color3.fromRGB(40, 100, 150),
	FUNCTION = Color3.fromRGB(40, 150, 70),
	ENUM = Color3.fromRGB(150, 150, 40),
	VARIABLE = Color3.fromRGB(80, 80, 80)
}

function NodeComponent.new(canvasParent, nodeData)
	local self = setmetatable({}, NodeComponent)
	self.nodeData = nodeData

	-- Main Container
	local frame = Instance.new("Frame")
	frame.Name = "Node_" .. nodeData.Id
	frame.Position = UDim2.fromOffset(nodeData.Position.X, nodeData.Position.Y)
	frame.BackgroundColor3 = Color3.fromRGB(25, 30, 42)
	frame.BorderSizePixel = 0
	frame.ZIndex = 10
	frame.Parent = canvasParent
	makeCorner(frame, 6)
	
	-- Outline
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(15, 20, 30)
	stroke.Thickness = 2
	stroke.Parent = frame

	-- Header
	local headerColor = nil
	if nodeData.Color then
		headerColor = nodeData.Color
	else 
		headerColor = TYPE_COLORS[nodeData.Type] or Color3.fromRGB(80, 80, 80)
	end
	
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 28)
	header.BackgroundColor3 = headerColor
	header.BorderSizePixel = 0
	header.Active = true -- Important for robust input capture
	header.ZIndex = 11
	header.Parent = frame
	makeCorner(header, 6)

	-- Fix bottom corners of header to be square
	local headerSquare = Instance.new("Frame")
	headerSquare.Size = UDim2.new(1, 0, 0, 6)
	headerSquare.Position = UDim2.new(0, 0, 1, -6)
	headerSquare.BackgroundColor3 = headerColor
	headerSquare.BorderSizePixel = 0
	headerSquare.ZIndex = 11
	headerSquare.Parent = header
	makeCorner(headerSquare, 0)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -20, 1, 0)
	title.Position = UDim2.new(0, 10, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = nodeData.Title or nodeData.Name
	title.TextColor3 = Color3.fromRGB(250, 250, 250)
	title.TextSize = 13
	title.Font = Enum.Font.GothamBold
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 12
	title.Parent = header

	-- Refresh Button (for dynamic nodes like Module Call or Events)
	if nodeData.Type == "METHOD" or nodeData.Type == "FUNCTION" or nodeData.Type == "EVENT" then
		local refreshBtn = Instance.new("TextButton")
		refreshBtn.Name = "RefreshBtn"
		refreshBtn.Size = UDim2.new(0, 20, 0, 20)
		refreshBtn.Position = UDim2.new(1, -25, 0.5, -10)
		refreshBtn.BackgroundTransparency = 1
		refreshBtn.Text = "🔄"
		refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		refreshBtn.TextSize = 12
		refreshBtn.Font = Enum.Font.GothamBold
		refreshBtn.ZIndex = 13
		refreshBtn.Parent = header
		
		refreshBtn.MouseButton1Click:Connect(function()
			self.OnRefresh:Fire()
		end)
	end

	-- Calculate adaptive width
	local titleWidth = TextService:GetTextSize(nodeData.Title or nodeData.Name, 13, Enum.Font.GothamBold, Vector2.new(1000, 1000)).X + 70
	
	-- Calculate max field width based on values
	local maxFieldWidth = 50
	for _, input in ipairs(nodeData:getInputs()) do
		if not input.IsExec then
			local val = tostring(input.Value or "")
			local valW = TextService:GetTextSize(val, 10, Enum.Font.Gotham, Vector2.new(1000, 1000)).X
			maxFieldWidth = math.max(maxFieldWidth, math.clamp(valW + 15, 50, 200))
		end
	end
	self.maxFieldWidth = maxFieldWidth

	local maxLeftWidth = 0
	for _, input in ipairs(nodeData:getInputs()) do
		if input.Name:sub(1, 2) == "__" then continue end
		local w = TextService:GetTextSize(input.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
		if input.DataType and not input.IsExec then
			local typeW = TextService:GetTextSize("(" .. input.DataType .. ")", 9, Enum.Font.Gotham, Vector2.new(1000, 1000)).X
			w += typeW + 5
		end
		if not input.IsExec then
			w += maxFieldWidth + 20 -- space for input field + padding
		end
		maxLeftWidth = math.max(maxLeftWidth, w + 25)
	end
	
	local maxRightWidth = 0
	for _, output in ipairs(nodeData:getOutputs()) do
		if output.Name:sub(1, 2) == "__" then continue end
		local w = TextService:GetTextSize(output.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
		if output.DataType and not output.IsExec then
			local typeW = TextService:GetTextSize("(" .. output.DataType .. ")", 9, Enum.Font.Gotham, Vector2.new(1000, 1000)).X
			w += typeW + 5
		end
		maxRightWidth = math.max(maxRightWidth, w + 25)
	end
	
	local calculatedWidth = math.max(160, titleWidth, maxLeftWidth + maxRightWidth + 30)

	-- Body
	local body = Instance.new("Frame")
	body.Name = "Body"
	body.Size = UDim2.new(1, 0, 1, -28)
	body.Position = UDim2.new(0, 0, 0, 28)
	body.BackgroundTransparency = 1
	body.ZIndex = 11
	body.Parent = frame
	
	local leftLayout = Instance.new("UIListLayout")
	leftLayout.FillDirection = Enum.FillDirection.Vertical
	leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
	leftLayout.Padding = UDim.new(0, 2)
	
	local leftFrame = Instance.new("Frame")
	leftFrame.Size = UDim2.new(0, maxLeftWidth, 1, -10)
	leftFrame.Position = UDim2.new(0, 5, 0, 5)
	leftFrame.BackgroundTransparency = 1
	leftFrame.Parent = body
	leftLayout.Parent = leftFrame
	self.leftFrame = leftFrame
	
	local rightLayout = Instance.new("UIListLayout")
	rightLayout.FillDirection = Enum.FillDirection.Vertical
	rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rightLayout.Padding = UDim.new(0, 2)
	
	local rightFrame = Instance.new("Frame")
	rightFrame.Size = UDim2.new(0, maxRightWidth, 1, -10)
	rightFrame.Position = UDim2.new(1, -maxRightWidth - 5, 0, 5)
	rightFrame.BackgroundTransparency = 1
	rightFrame.Parent = body
	rightLayout.Parent = rightFrame
	self.rightFrame = rightFrame

	self.pins = {}
	self.connections = {}
	self.isOutputCollapsed = (#nodeData:getOutputs() > 5)

	self.OnSelect = Instance.new("BindableEvent")
	self.OnPinDragStart = Instance.new("BindableEvent")
	self.OnPinDragEnd = Instance.new("BindableEvent")
	self.OnPinHover = Instance.new("BindableEvent")
	self.OnPinHoverEnd = Instance.new("BindableEvent")
	self.OnHover = Instance.new("BindableEvent")
	self.OnHoverEnd = Instance.new("BindableEvent")
	self.OnKeyDown = Instance.new("BindableEvent")
	self.OnRefresh = Instance.new("BindableEvent")

	-- Create Inputs
	for _, input in ipairs(nodeData:getInputs()) do
		if input.Name:sub(1, 2) == "__" then continue end
		local isExec = input.IsExec
		local pinObj = makePin(leftFrame, input.Name, false, isExec, input.Choices, maxFieldWidth, input.DataType)
		self.pins[input.Id] = pinObj
		
		if pinObj.inputField then
			pinObj.inputField.Text = input.Value or ""
			
			pinObj.inputField:GetPropertyChangedSignal("Text"):Connect(function()
				input.Value = pinObj.inputField.Text
				self:UpdateLayout()
			end)

			pinObj.inputField.FocusLost:Connect(function()
				input.Value = pinObj.inputField.Text
				self:UpdateLayout()
			end)
		elseif pinObj.choiceButton then
			pinObj.choiceButton.Text = input.Value or "select"
			pinObj.choiceButton.MouseButton1Click:Connect(function()
				-- Find the top-level container (ScreenGui, DockWidget, or the canvas itself)
				local topContainer = canvasParent:FindFirstAncestorWhichIsA("LayerCollector") or canvasParent
				
				-- Calculate position relative to the top container
				local buttonPos = pinObj.choiceButton.AbsolutePosition
				local containerPos = if topContainer:IsA("LayerCollector") then Vector2.new(0, 0) else topContainer.AbsolutePosition
				local relativePos = buttonPos - containerPos + Vector2.new(0, 20)
				
				ChoiceModal.prompt(topContainer, input.Name, input.Choices, function(choice)
					input.Value = choice
					pinObj.choiceButton.Text = choice
					self:UpdateLayout()
				end, relativePos)
			end)
		end

		pinObj.row.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				self.OnPinDragStart:Fire(self.nodeData.Id, input, false, pinObj.pin, inp.Position)
				
				local endConn
				endConn = inp.Changed:Connect(function()
					if inp.UserInputState == Enum.UserInputState.End then
						self.OnPinDragEnd:Fire()
						endConn:Disconnect()
					end
				end)
			end
		end)
		pinObj.pin.MouseEnter:Connect(function()
			self.OnPinHover:Fire(self.nodeData.Id, input, false, pinObj.pin)
		end)
		pinObj.pin.MouseLeave:Connect(function()
			self.OnPinHoverEnd:Fire(self.nodeData, input, false, pinObj.pin)
		end)
	end

	-- Create Outputs
	for _, output in ipairs(nodeData:getOutputs()) do
		if output.Name:sub(1, 2) == "__" then continue end
		local isExec = output.IsExec
		local pinObj = makePin(rightFrame, output.Name, true, isExec, nil, nil, output.DataType)
		self.pins[output.Id] = pinObj
		
		pinObj.row.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				self.OnPinDragStart:Fire(self.nodeData.Id, output, true, pinObj.pin, inp.Position)
				
				local endConn
				endConn = inp.Changed:Connect(function()
					if inp.UserInputState == Enum.UserInputState.End then
						self.OnPinDragEnd:Fire()
						endConn:Disconnect()
					end
				end)
			end
		end)
		pinObj.pin.MouseEnter:Connect(function()
			self.OnPinHover:Fire(self.nodeData.Id, output, true, pinObj.pin)
		end)
		pinObj.pin.MouseLeave:Connect(function()
			self.OnPinHoverEnd:Fire(self.nodeData, output, true, pinObj.pin)
		end)
	end

	-- Expansion Button (for nodes with many outputs)
	self.expander = nil
	if #nodeData:getOutputs() > 5 then
		local expanderRow = Instance.new("TextButton")
		expanderRow.Text = ""
		expanderRow.Size = UDim2.new(1, 0, 0, 18)
		expanderRow.BackgroundTransparency = 1
		expanderRow.Parent = rightFrame
		expanderRow.LayoutOrder = 1000 -- Always at the end
		
		local expanderLabel = Instance.new("TextLabel")
		expanderLabel.Size = UDim2.new(1, -5, 1, 0)
		expanderLabel.BackgroundTransparency = 1
		expanderLabel.Text = if self.isOutputCollapsed then "▼ Show All" else "▲ Show Less"
		expanderLabel.TextColor3 = Color3.fromRGB(100, 150, 200)
		expanderLabel.TextSize = 10
		expanderLabel.Font = Enum.Font.GothamBold
		expanderLabel.TextXAlignment = Enum.TextXAlignment.Right
		expanderLabel.Parent = expanderRow
		
		self.expander = expanderRow
		self.expanderLabel = expanderLabel
		
		expanderRow.MouseButton1Click:Connect(function()
			self.isOutputCollapsed = not self.isOutputCollapsed
			self.expanderLabel.Text = if self.isOutputCollapsed then "▼ Show All" else "▲ Show Less"
			self:UpdateLayout()
		end)
	end

	-- Auto-size frame based on pins
	local maxPins = math.max(#nodeData:getInputs(), #nodeData:getOutputs())
	local bodyHeight = math.max(40, maxPins * 26 + 10)
	
	if nodeData.AllowDynamicPins then
		bodyHeight += 30
		local footer = Instance.new("Frame")
		footer.Size = UDim2.new(1, -10, 0, 24)
		footer.Position = UDim2.new(0, 5, 0, bodyHeight - 27)
		footer.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
		footer.BorderSizePixel = 0
		footer.ZIndex = 11
		footer.Parent = body
		makeCorner(footer, 4)
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, -50, 1, 0)
		label.Position = UDim2.new(0, 8, 0, 0)
		label.BackgroundTransparency = 1
		label.Text = "Add/Remove Parameter"
		label.TextColor3 = Color3.fromRGB(100, 115, 140)
		label.TextSize = 10
		label.Font = Enum.Font.GothamMedium
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.ZIndex = 12
		label.Parent = footer

		local addBtn = Instance.new("TextButton")
		addBtn.Size = UDim2.new(0, 18, 0, 18)
		addBtn.Position = UDim2.new(1, -42, 0.5, -9)
		addBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
		addBtn.Text = "+"
		addBtn.TextColor3 = Color3.fromRGB(150, 255, 170)
		addBtn.TextSize = 14
		addBtn.Font = Enum.Font.GothamBold
		addBtn.ZIndex = 13
		addBtn.Parent = footer
		makeCorner(addBtn, 4)
		
		addBtn.MouseButton1Click:Connect(function()
			nodeData.OnAddPin:Fire()
		end)
		
		local removeBtn = Instance.new("TextButton")
		removeBtn.Size = UDim2.new(0, 18, 0, 18)
		removeBtn.Position = UDim2.new(1, -20, 0.5, -9)
		removeBtn.BackgroundColor3 = Color3.fromRGB(40, 50, 65)
		removeBtn.Text = "-"
		removeBtn.TextColor3 = Color3.fromRGB(255, 140, 140)
		removeBtn.TextSize = 14
		removeBtn.Font = Enum.Font.GothamBold
		removeBtn.ZIndex = 13
		removeBtn.Parent = footer
		makeCorner(removeBtn, 4)
		
		removeBtn.MouseButton1Click:Connect(function()
			nodeData.OnRemovePin:Fire()
		end)
	end

	self.frame = frame
	self.header = header
	self.stroke = stroke
	self.selected = false

	frame.Size = UDim2.new(0, calculatedWidth, 0, bodyHeight + 28)
	self:UpdateLayout()

	self:_makeDraggable()

	-- Interaction Events
	self.frame.MouseEnter:Connect(function()
		self.OnHover:Fire()
		if not self.selected then
			self.stroke.Color = Color3.fromRGB(50, 75, 110)
		end
	end)
	self.frame.MouseLeave:Connect(function()
		self.OnHoverEnd:Fire()
		if not self.selected then
			self.stroke.Color = Color3.fromRGB(15, 20, 30)
		end
	end)

	self.header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			self.OnKeyDown:Fire(input.KeyCode)
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:Select()
			self.OnSelect:Fire()
		end
	end)

	self.frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			self.OnKeyDown:Fire(input.KeyCode)
		end
	end)

	return self
end

function NodeComponent:Select()
	self.selected = true
	self.stroke.Color = Color3.fromRGB(220, 160, 40)
	self.stroke.Thickness = 2
	self.frame.ZIndex = 15 -- Bring to front
end

function NodeComponent:Deselect()
	self.selected = false
	self.stroke.Color = Color3.fromRGB(15, 20, 30)
	self.stroke.Thickness = 2
	self.frame.ZIndex = 10
end

function NodeComponent:_makeDraggable()
	local dragging = false
	local dragStart = nil
	local startPos = nil
	-- Stores starting positions of ALL co-selected nodes during a multi-drag
	local coStartPositions = {}

	self.header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.frame.Position
			
			-- Suppress canvas box-select while we are node-dragging
			if self._canvas then
				self._canvas:SetSuppressBoxSelect(true)
			end
			
			-- Snapshot start positions of all selected nodes for multi-drag
			coStartPositions = {}
			if self._getSelectedNodes then
				for _, vn in ipairs(self._getSelectedNodes()) do
					coStartPositions[vn] = vn.frame.Position
				end
			end
			-- Always include self
			coStartPositions[self] = startPos
			
			self:Select()
			self.OnSelect:Fire()
			
			local endConn
			local dragConn

			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					coStartPositions = {}
					if dragConn then
						dragConn:Disconnect()
						dragConn = nil
					end
					endConn:Disconnect()
					-- Re-enable canvas box-select
					if self._canvas then
						self._canvas:SetSuppressBoxSelect(false)
					end
				end
			end)
			
			local canvasFrame = self.frame.Parent and self.frame.Parent.Parent
			if canvasFrame and canvasFrame:IsA("GuiObject") then
				dragConn = canvasFrame.InputChanged:Connect(function(moveInput)
					if moveInput.UserInputType == Enum.UserInputType.MouseMovement and dragging then
						local zoom = 1
						if self.frame.Parent then
							local uiScale = self.frame.Parent:FindFirstChildOfClass("UIScale")
							if uiScale then zoom = uiScale.Scale end
						end

						local delta = moveInput.Position - dragStart
						local dx = delta.X / zoom
						local dy = delta.Y / zoom
						
						-- Snap helper: round to nearest grid multiple
						local snapSize = self._canvas and self._canvas:IsSnapEnabled() and self._canvas:GetSnapSize() or nil
						local function snapVal(v)
							if snapSize then
								return math.round(v / snapSize) * snapSize
							end
							return v
						end
						
						-- Move all co-selected nodes
						for vn, sPos in pairs(coStartPositions) do
							local newX = snapVal(sPos.X.Offset + dx)
							local newY = snapVal(sPos.Y.Offset + dy)
							vn.frame.Position = UDim2.new(0, newX, 0, newY)
							vn.nodeData:editPosition(Vector2.new(newX, newY))
						end
					end
				end)
			end
		end
	end)
end

-- Inject a callback returning all currently selected NodeComponent instances,
-- and a reference to the Canvas object (for box-select suppression).
function NodeComponent:SetMultiSelectContext(getSelectedNodesFn, canvasObj)
	self._getSelectedNodes = getSelectedNodesFn
	self._canvas = canvasObj
end

function NodeComponent:GetPins()
	local allPins = {}
	for _, input in ipairs(self.nodeData:getInputs()) do
		local p = self.pins[input.Id]
		if p then 
			table.insert(allPins, { pinData = input, isOutput = false, pinGui = p.pin }) 
		end
	end
	for _, output in ipairs(self.nodeData:getOutputs()) do
		local p = self.pins[output.Id]
		if p then 
			table.insert(allPins, { pinData = output, isOutput = true, pinGui = p.pin }) 
		end
	end
	return allPins
end

function NodeComponent:UpdateLayout()
	local nodeData = self.nodeData
	
	-- 1. Recalculate maxFieldWidth based on current values
	local maxFieldWidth = 50
	for _, input in ipairs(nodeData:getInputs()) do
		if not input.IsExec then
			local p = self.pins[input.Id]
			local text = (p and p.inputField) and p.inputField.Text or tostring(input.Value or "")
			local valW = TextService:GetTextSize(text, 10, Enum.Font.Gotham, Vector2.new(1000, 1000)).X
			maxFieldWidth = math.max(maxFieldWidth, math.clamp(valW + 15, 50, 250))
		end
	end
	self.maxFieldWidth = maxFieldWidth

	-- 2. Recalculate adaptive widths for columns
	local titleWidth = TextService:GetTextSize(nodeData.Title or nodeData.Name, 13, Enum.Font.GothamBold, Vector2.new(1000, 1000)).X + 70
	
	local maxLeftWidth = 0
	for _, input in ipairs(nodeData:getInputs()) do
		if input.Name:sub(1, 2) == "__" then continue end
		local w = TextService:GetTextSize(input.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
		if input.DataType and not input.IsExec then
			local typeW = TextService:GetTextSize("(" .. input.DataType .. ")", 9, Enum.Font.Gotham, Vector2.new(1000, 1000)).X
			w += typeW + 5
		end
		if not input.IsExec then
			local isConnected = self.connections[input.Id]
			if not isConnected then
				w += maxFieldWidth + 20
			end
		end
		maxLeftWidth = math.max(maxLeftWidth, w + 25)
	end
	
	local maxRightWidth = 0
	for _, output in ipairs(nodeData:getOutputs()) do
		if output.Name:sub(1, 2) == "__" then continue end
		local w = TextService:GetTextSize(output.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
		if output.DataType and not output.IsExec then
			local typeW = TextService:GetTextSize("(" .. output.DataType .. ")", 9, Enum.Font.Gotham, Vector2.new(1000, 1000)).X
			w += typeW + 5
		end
		maxRightWidth = math.max(maxRightWidth, w + 25)
	end
	
	local calculatedWidth = math.max(160, titleWidth, maxLeftWidth + maxRightWidth + 30)
	
	-- 3. Update all input fields and labels
	for _, input in ipairs(nodeData:getInputs()) do
		local pinObj = self.pins[input.Id]
		if pinObj then
			local isConnected = self.connections[input.Id]
			if pinObj.inputField then
				pinObj.inputField.Visible = not isConnected
				pinObj.inputField.Size = UDim2.new(0, maxFieldWidth, 0, 18)
				pinObj.fieldWidth = maxFieldWidth
			end
			if pinObj.choiceButton then
				pinObj.choiceButton.Visible = not isConnected
				pinObj.choiceButton.Size = UDim2.new(0, math.max(60, maxFieldWidth), 0, 18)
				pinObj.fieldWidth = math.max(60, maxFieldWidth)
			end
			
			if pinObj.label then
				local nameW = TextService:GetTextSize(input.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
				if isConnected then
					pinObj.label.Position = UDim2.new(0, 15, 0, 0)
					pinObj.label.Size = UDim2.new(0, nameW, 1, 0)
				else
					local offset = pinObj.fieldWidth + 20
					pinObj.label.Position = UDim2.new(0, offset, 0, 0)
					pinObj.label.Size = UDim2.new(0, nameW, 1, 0)
				end
				
				if pinObj.typeLabel then
					pinObj.typeLabel.Position = UDim2.new(0, pinObj.label.Position.X.Offset + nameW + 5, 0, 0)
					pinObj.typeLabel.Size = UDim2.new(0, 100, 1, 0)
				end
			end
		end
	end

	-- 4. Show/hide outputs based on connection and collapsed state
	local visibleOutputs = 0
	local outputs = nodeData:getOutputs()
	for i, output in ipairs(outputs) do
		local pinObj = self.pins[output.Id]
		if pinObj then
			local isConnected = self.connections[output.Id]
			local shouldBeVisible = true
			if self.isOutputCollapsed and i > 5 and not isConnected then
				shouldBeVisible = false
			end
			pinObj.row.Visible = shouldBeVisible
			if shouldBeVisible then 
				visibleOutputs += 1 
				
				-- Update type label position for outputs
				if pinObj.typeLabel and pinObj.label then
					local nameW = TextService:GetTextSize(output.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
					pinObj.label.Size = UDim2.new(0, nameW, 1, 0)
					pinObj.label.Position = UDim2.new(1, -nameW - 15, 0, 0)
					
					pinObj.typeLabel.Position = UDim2.new(0, 0, 0, 0)
					pinObj.typeLabel.Size = UDim2.new(1, -nameW - 20, 1, 0)
					pinObj.typeLabel.TextXAlignment = Enum.TextXAlignment.Right
				end
			end
		end
	end
	
	-- 5. Final size updates
	local visibleInputs = #nodeData:getInputs()
	local maxPins = math.max(visibleInputs, visibleOutputs)
	if self.expander then
		maxPins += 1
	end
	
	local bodyHeight = math.max(40, maxPins * 26 + 10)
	if nodeData.AllowDynamicPins then
		bodyHeight += 30
	end
	
	self.leftFrame.Size = UDim2.new(0, maxLeftWidth, 1, -10)
	self.rightFrame.Size = UDim2.new(0, maxRightWidth, 1, -10)
	self.rightFrame.Position = UDim2.new(1, -maxRightWidth - 5, 0, 5)
	
	self.frame.Size = UDim2.new(0, calculatedWidth, 0, bodyHeight + 28)
end

function NodeComponent:UpdatePinState(pinId, isConnected)
	self.connections[pinId] = isConnected
	self:UpdateLayout()
end

function NodeComponent:Destroy()
	self.frame:Destroy()
end

return NodeComponent
