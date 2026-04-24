local NodeComponent = {}
NodeComponent.__index = NodeComponent

local TextService = game:GetService("TextService")

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function makePin(parent, labelText, isOutput, isExec)
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

	local inputField = nil
	if not isOutput and not isExec then
		inputField = Instance.new("TextBox")
		inputField.Size = UDim2.new(0, 50, 0, 18)
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
		label.Position = UDim2.new(0, 70, 0, 0)
		label.Size = UDim2.new(1, -75, 1, 0)
	end

	return { row = row, pin = pin, inputField = inputField }
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

	-- Refresh Button (for dynamic nodes like Module Call)
	if nodeData.Type == "METHOD" or nodeData.Type == "FUNCTION" then
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
	
	local maxLeftWidth = 0
	for _, input in ipairs(nodeData:getInputs()) do
		if input.Name:sub(1, 2) == "__" then continue end
		local w = TextService:GetTextSize(input.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
		if not input.IsExec then
			w += 65 -- space for input field (50 size + padding)
		end
		maxLeftWidth = math.max(maxLeftWidth, w + 25)
	end
	
	local maxRightWidth = 0
	for _, output in ipairs(nodeData:getOutputs()) do
		if output.Name:sub(1, 2) == "__" then continue end
		local w = TextService:GetTextSize(output.Name, 11, Enum.Font.GothamMedium, Vector2.new(1000, 1000)).X
		maxRightWidth = math.max(maxRightWidth, w + 25)
	end
	
	local calculatedWidth = math.max(160, titleWidth, maxLeftWidth + maxRightWidth + 30)

	-- Body
	local body = Instance.new("Frame")
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

	self.pins = {}

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
		local pinObj = makePin(leftFrame, input.Name, false, isExec)
		self.pins[input.Id] = pinObj
		
		if pinObj.inputField then
			pinObj.inputField.Text = input.Value or ""
			pinObj.inputField.FocusLost:Connect(function()
				input.Value = pinObj.inputField.Text
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
		local pinObj = makePin(rightFrame, output.Name, true, isExec)
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

	-- Auto-size frame based on pins
	local maxPins = math.max(#nodeData:getInputs(), #nodeData:getOutputs())
	local bodyHeight = math.max(40, maxPins * 26 + 10)
	frame.Size = UDim2.new(0, calculatedWidth, 0, bodyHeight + 28)

	self.frame = frame
	self.header = header
	self.stroke = stroke
	self.selected = false

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
	local RunService = game:GetService("RunService")
	local dragging = false
	local dragInput = nil
	local dragStart = nil
	local startPos = nil

	self.header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.frame.Position
			
			self:Select()
			self.OnSelect:Fire()
			
			local endConn
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					endConn:Disconnect()
				end
			end)
		end
	end)

	self.header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)

	RunService.Heartbeat:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			local newX = startPos.X.Offset + delta.X
			local newY = startPos.Y.Offset + delta.Y
			self.frame.Position = UDim2.new(0, newX, 0, newY)
			self.nodeData:editPosition(Vector2.new(newX, newY))
		end
	end)
end

function NodeComponent:GetPins()
	local allPins = {}
	for _, input in ipairs(self.nodeData:getInputs()) do
		local p = self.pins[input.Id]
		if p then table.insert(allPins, { pinData = input, isOutput = false, pinGui = p.pin }) end
	end
	for _, output in ipairs(self.nodeData:getOutputs()) do
		local p = self.pins[output.Id]
		if p then table.insert(allPins, { pinData = output, isOutput = true, pinGui = p.pin }) end
	end
	return allPins
end

function NodeComponent:UpdatePinState(pinId, isConnected)
	local pinObj = self.pins[pinId]
	if pinObj and pinObj.inputField then
		pinObj.inputField.Visible = not isConnected
	end
end

function NodeComponent:Destroy()
	self.frame:Destroy()
end

return NodeComponent
