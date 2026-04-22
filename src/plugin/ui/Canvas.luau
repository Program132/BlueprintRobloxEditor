-- Canvas : the main viewport for the blueprint graph.
-- Uses CanvasGroup so descendants share group transparency / color tinting.
-- Dot grid adapts to the current widget size automatically.

local Canvas = {}
Canvas.__index = Canvas

local DOT_SPACING = 32
local DOT_SIZE    = 2
local DOT_COLOR   = Color3.fromRGB(42, 58, 85)
local BG_COLOR    = Color3.fromRGB(14, 19, 30)

function Canvas.new(parent)
	local self = setmetatable({}, Canvas)

	local group = Instance.new("CanvasGroup")
	group.Name = "Canvas"
	group.Size = UDim2.new(1, 0, 1, -40)
	group.Position = UDim2.new(0, 0, 0, 40)
	group.BackgroundColor3 = BG_COLOR
	group.BorderSizePixel = 0
	group.GroupTransparency = 0
	group.Active = true -- Important for catching clicks
	group.Parent = parent

	local placeholder = Instance.new("TextLabel")
	placeholder.Name = "Placeholder"
	placeholder.Size = UDim2.new(1, 0, 1, 0)
	placeholder.BackgroundTransparency = 1
	placeholder.Text = "No project open.\nUse '+ New Project' or 'Open Project' above."
	placeholder.TextColor3 = Color3.fromRGB(70, 85, 110)
	placeholder.TextSize = 14
	placeholder.Font = Enum.Font.Gotham
	placeholder.TextWrapped = true
	placeholder.Parent = group

	self._group       = group
	self._placeholder = placeholder
	self._gridFrame   = nil
	self._gridActive  = false
	self._resizeConn  = nil
	
	self._panX = 0
	self._panY = 0
	
	self._nodeContainer = Instance.new("Frame")
	self._nodeContainer.Name = "NodeContainer"
	self._nodeContainer.Size = UDim2.new(1, 0, 1, 0)
	self._nodeContainer.BackgroundTransparency = 1
	self._nodeContainer.ZIndex = 5
	self._nodeContainer.Parent = group

	self:_setupPanning()

	return self
end

function Canvas:_setupPanning()
	local UserInputService = game:GetService("UserInputService")
	local RunService = game:GetService("RunService")

	local panning = false
	local panStartPos = nil
	local startPanX = 0
	local startPanY = 0

	local mouseInCanvas = false
	local keys = {
		[Enum.KeyCode.Up] = false,
		[Enum.KeyCode.Down] = false,
		[Enum.KeyCode.Left] = false,
		[Enum.KeyCode.Right] = false,
		[Enum.KeyCode.W] = false,
		[Enum.KeyCode.A] = false,
		[Enum.KeyCode.S] = false,
		[Enum.KeyCode.D] = false,
	}

	self._group.MouseEnter:Connect(function() 
		print("[Canvas] Mouse entered canvas area")
		mouseInCanvas = true 
	end)
	self._group.MouseLeave:Connect(function() 
		print("[Canvas] Mouse left canvas area")
		mouseInCanvas = false 
	end)

	self._group.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
			print("[Canvas] Panning started (Right/Middle click)")
			panning = true
			panStartPos = input.Position
			startPanX = self._panX
			startPanY = self._panY
			
			local endConn
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					panning = false
					endConn:Disconnect()
					
					-- Right-click Context Menu
					if input.UserInputType == Enum.UserInputType.MouseButton2 then
						local delta = input.Position - panStartPos
						if delta.Magnitude < 5 and self._onRightClickCallback then
							print("[Canvas] Firing Right-Click Context Menu")
							self._onRightClickCallback(Vector2.new(input.Position.X, input.Position.Y))
						end
					end
				end
			end)
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			print("[Canvas] Left click detected inside canvas")
			if self._onLeftClickCallback then
				self._onLeftClickCallback()
			end
		elseif input.UserInputType == Enum.UserInputType.Keyboard then
			if self._onKeyDownCallback then
				self._onKeyDownCallback(input.KeyCode)
			end
		end
	end)

	self._group.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			if self._onMouseMoveCallback then
				self._onMouseMoveCallback(input.Position)
			end
			
			if panning then
				local delta = input.Position - panStartPos
				self._panX = startPanX + delta.X
				self._panY = startPanY + delta.Y
				
				self._nodeContainer.Position = UDim2.fromOffset(self._panX, self._panY)
				
				if self._gridFrame then
					self._gridFrame.Position = UDim2.fromOffset(self._panX % DOT_SPACING, self._panY % DOT_SPACING)
				end
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		-- In a plugin, gpe is often true just because the widget has focus.
		-- So instead of checking gpe, we check if they're typing in a TextBox.
		if UserInputService:GetFocusedTextBox() then return end
		
		if keys[input.KeyCode] ~= nil then
			keys[input.KeyCode] = true
			print("[Canvas] Key pressed:", input.KeyCode.Name)
		end
	end)

	UserInputService.InputEnded:Connect(function(input, gpe)
		if keys[input.KeyCode] ~= nil then
			keys[input.KeyCode] = false
		end
	end)

	local PAN_SPEED = 600
	RunService.Heartbeat:Connect(function(dt)
		if not mouseInCanvas then return end
		
		local dx, dy = 0, 0
		if keys[Enum.KeyCode.Left] or keys[Enum.KeyCode.A] then dx = dx + 1 end
		if keys[Enum.KeyCode.Right] or keys[Enum.KeyCode.D] then dx = dx - 1 end
		if keys[Enum.KeyCode.Up] or keys[Enum.KeyCode.W] then dy = dy + 1 end
		if keys[Enum.KeyCode.Down] or keys[Enum.KeyCode.S] then dy = dy - 1 end
		
		if dx ~= 0 or dy ~= 0 then
			self._panX = self._panX + (dx * PAN_SPEED * dt)
			self._panY = self._panY + (dy * PAN_SPEED * dt)
			
			self._nodeContainer.Position = UDim2.fromOffset(self._panX, self._panY)
			
			if self._gridFrame then
				self._gridFrame.Position = UDim2.fromOffset(self._panX % DOT_SPACING, self._panY % DOT_SPACING)
			end
		end
	end)
end

-- ─── Layout ────────────────────────────────────────────────────────────────────

function Canvas:SetLeftOffset(px)
	self._group.Size     = UDim2.new(1, -px, 1, -40)
	self._group.Position = UDim2.new(0, px, 0, 40)
end

-- ─── Dot grid ──────────────────────────────────────────────────────────────────

local function buildGrid(gridFrame, absSize)
	-- Clear old dots
	for _, child in gridFrame:GetChildren() do
		child:Destroy()
	end

	local cols = math.min(math.ceil(absSize.X / DOT_SPACING) + 2, 80)
	local rows = math.min(math.ceil(absSize.Y / DOT_SPACING) + 2, 60)

	for row = -1, rows do
		for col = -1, cols do
			local dot = Instance.new("Frame")
			dot.Size     = UDim2.new(0, DOT_SIZE, 0, DOT_SIZE)
			dot.Position = UDim2.new(0, col * DOT_SPACING, 0, row * DOT_SPACING)
			dot.BackgroundColor3 = DOT_COLOR
			dot.BorderSizePixel  = 0

			local corner = Instance.new("UICorner")
			corner.CornerRadius = UDim.new(1, 0)
			corner.Parent = dot

			dot.Parent = gridFrame
		end
	end
end

function Canvas:ShowGrid()
	if self._gridActive then return end
	self._gridActive = true

	self._placeholder.Visible = false

	local gridFrame = Instance.new("Frame")
	gridFrame.Name = "Grid"
	gridFrame.Size = UDim2.new(1, 0, 1, 0)
	gridFrame.BackgroundTransparency = 1
	gridFrame.ZIndex = 1
	gridFrame.Parent = self._group

	self._gridFrame = gridFrame

	-- Build once now, then rebuild whenever the widget is resized
	task.defer(function()
		buildGrid(gridFrame, self._group.AbsoluteSize)
	end)

	self._resizeConn = self._group:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		buildGrid(gridFrame, self._group.AbsoluteSize)
	end)
end

function Canvas:OnRightClick(callback)
	self._onRightClickCallback = callback
end

function Canvas:OnLeftClick(callback)
	self._onLeftClickCallback = callback
end

function Canvas:OnMouseMove(callback)
	self._onMouseMoveCallback = callback
end

function Canvas:OnKeyDown(callback)
	self._onKeyDownCallback = callback
end

function Canvas:HideGrid()
	self._gridActive = false
	if self._resizeConn then
		self._resizeConn:Disconnect()
		self._resizeConn = nil
	end
	if self._gridFrame then
		self._gridFrame:Destroy()
		self._gridFrame = nil
	end
end

-- ─── Placeholder ──────────────────────────────────────────────────────────────

function Canvas:SetPlaceholder(text)
	self._placeholder.Visible = true
	self._placeholder.Text    = text
end

function Canvas:HidePlaceholder()
	self._placeholder.Visible = false
end

-- ─── Group effects ────────────────────────────────────────────────────────────

function Canvas:SetTransparency(t)
	self._group.GroupTransparency = t
end

function Canvas:GetInstance()
	return self._group
end

function Canvas:GetNodeContainer()
	return self._nodeContainer
end

function Canvas:GetPanOffset()
	return Vector2.new(self._panX, self._panY)
end

return Canvas