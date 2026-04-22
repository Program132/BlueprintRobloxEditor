local NodeComponent = {}
NodeComponent.__index = NodeComponent

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function makePin(parent, labelText, isOutput, isExec)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, 24)
	row.BackgroundTransparency = 1
	row.Parent = parent

	local pin = Instance.new("Frame")
	pin.Size = UDim2.new(0, 10, 0, 10)
	pin.Position = UDim2.new(isOutput and 1 or 0, isOutput and -5 or -5, 0.5, -5)
	pin.BackgroundColor3 = isExec and Color3.fromRGB(240, 240, 240) or Color3.fromRGB(110, 180, 240)
	pin.BorderSizePixel = 0
	pin.ZIndex = 12
	pin.Parent = row
	makeCorner(pin, 5)

	-- Add outline to pin
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(20, 25, 35)
	stroke.Thickness = 1
	stroke.Parent = pin

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(isOutput and 0 or 0, isOutput and 10 or 20, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = Color3.fromRGB(200, 215, 230)
	label.TextSize = 11
	label.Font = Enum.Font.GothamMedium
	label.TextXAlignment = isOutput and Enum.TextXAlignment.Right or Enum.TextXAlignment.Left
	label.ZIndex = 11
	label.Parent = row

	return { row = row, pin = pin }
end

local TYPE_COLORS = {
	EVENT = Color3.fromRGB(150, 40, 40),
	METHOD = Color3.fromRGB(40, 100, 150),
	FUNCTION = Color3.fromRGB(40, 150, 70),
	ENUM = Color3.fromRGB(150, 150, 40)
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
	local headerColor = TYPE_COLORS[nodeData.Type] or Color3.fromRGB(80, 80, 80)
	
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
	leftFrame.Size = UDim2.new(0.5, 0, 1, -10)
	leftFrame.Position = UDim2.new(0, 0, 0, 5)
	leftFrame.BackgroundTransparency = 1
	leftFrame.Parent = body
	leftLayout.Parent = leftFrame

	local rightLayout = Instance.new("UIListLayout")
	rightLayout.FillDirection = Enum.FillDirection.Vertical
	rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rightLayout.Padding = UDim.new(0, 2)
	
	local rightFrame = Instance.new("Frame")
	rightFrame.Size = UDim2.new(0.5, 0, 1, -10)
	rightFrame.Position = UDim2.new(0.5, 0, 0, 5)
	rightFrame.BackgroundTransparency = 1
	rightFrame.Parent = body
	rightLayout.Parent = rightFrame

	self.pins = {}

	-- Create Inputs
	local maxInputWidth = 0
	for _, input in ipairs(nodeData:getInputs()) do
		local isExec = (input.Name == "Exec")
		local pinObj = makePin(leftFrame, input.Name, false, isExec)
		self.pins[input.Id] = pinObj
	end

	-- Create Outputs
	local maxOutputWidth = 0
	for _, output in ipairs(nodeData:getOutputs()) do
		local isExec = (output.Name == "Exec")
		local pinObj = makePin(rightFrame, output.Name, true, isExec)
		self.pins[output.Id] = pinObj
	end

	-- Auto-size frame based on pins
	local rows = math.max(#nodeData:getInputs(), #nodeData:getOutputs())
	local minHeight = 28 + 10 + (rows * 26)
	frame.Size = UDim2.new(0, 160, 0, minHeight)

	self.frame = frame
	self.header = header
	self.stroke = stroke
	self.selected = false
	self.OnSelect = Instance.new("BindableEvent")

	self:_makeDraggable()
	self:_setupEffects()

	return self
end

function NodeComponent:_setupEffects()
	local normalStroke = Color3.fromRGB(15, 20, 30)
	local hoverStroke = Color3.fromRGB(80, 100, 140)
	local selectStroke = Color3.fromRGB(220, 160, 40)

	self.frame.MouseEnter:Connect(function()
		if not self.selected then
			self.stroke.Color = hoverStroke
		end
	end)

	self.frame.MouseLeave:Connect(function()
		if not self.selected then
			self.stroke.Color = normalStroke
		end
	end)

	-- We can toggle selection on click
	self.header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self:Select()
			self.OnSelect:Fire()
		end
	end)
end

function NodeComponent:Select()
	-- Deselect others in the same container? For now just visual toggle
	-- Ideally, this should communicate with a global selection manager
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
		print(string.format("[NodeDrag] InputBegan on %s. Type: %s, Pos: %s", self.nodeData.Name, input.UserInputType.Name, tostring(input.Position)))
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = self.frame.Position
			print(string.format("[NodeDrag] Started Drag! startPos: %s", tostring(startPos)))
			
			self:Select()
			self.OnSelect:Fire()
			
			local endConn
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					print("[NodeDrag] Ended Drag! MouseButton1 released.")
					endConn:Disconnect()
				end
			end)
		end
	end)

	self.header.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if dragInput == nil then
				print("[NodeDrag] Captured MouseMovement input reference for the first time.")
			end
			dragInput = input
		end
	end)

	local lastPrint = 0
	RunService.Heartbeat:Connect(function()
		if dragging and dragInput then
			local delta = dragInput.Position - dragStart
			local newX = startPos.X.Offset + delta.X
			local newY = startPos.Y.Offset + delta.Y
			self.frame.Position = UDim2.new(0, newX, 0, newY)
			
			self.nodeData:editPosition(Vector2.new(newX, newY))
			
			if os.clock() - lastPrint > 0.5 then
				print(string.format("[NodeDrag] Moving %s. Delta: %s, NewPos: (%d, %d)", self.nodeData.Name, tostring(delta), newX, newY))
				lastPrint = os.clock()
			end
		end
	end)
end

function NodeComponent:Destroy()
	self.frame:Destroy()
end

return NodeComponent
