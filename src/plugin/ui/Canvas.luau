-- Canvas : the main viewport for the blueprint graph.
-- Uses CanvasGroup so descendants share group transparency / color tinting.
-- Dot grid adapts to the current widget size automatically.

local Canvas = {}
Canvas.__index = Canvas

local DOT_SPACING = 32
local DOT_SIZE    = 2
local DOT_COLOR   = Color3.fromRGB(42, 58, 85)
local BG_COLOR    = Color3.fromRGB(14, 19, 30)

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

function Canvas.new(parent)
	local self = setmetatable({}, Canvas)

	local group = Instance.new("Frame")
	group.Name = "Canvas"
	group.Size = UDim2.new(1, 0, 1, -40)
	group.Position = UDim2.new(0, 0, 0, 40)
	group.BackgroundColor3 = BG_COLOR
	group.BorderSizePixel = 0
	group.ClipsDescendants = true
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
	placeholder.ZIndex = 10
	placeholder.Parent = group

	self._group       = group
	self._placeholder = placeholder
	self._gridFrame   = nil
	self._gridActive  = false
	self._resizeConn  = nil
	
	self._panX = 0
	self._panY = 0
	self._zoom = 1.0
	
	self._nodeContainer = Instance.new("Frame")
	self._nodeContainer.Name = "NodeContainer"
	self._nodeContainer.Size = UDim2.new(1, 0, 1, 0)
	self._nodeContainer.BackgroundTransparency = 1
	self._nodeContainer.ZIndex = 5
	self._nodeContainer.Parent = group

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = self._zoom
	uiScale.Parent = self._nodeContainer
	self._uiScale = uiScale

	-- Floating Control Bar (pill with two buttons)
	local controlBar = Instance.new("Frame")
	controlBar.Name = "CanvasControls"
	controlBar.Size = UDim2.new(0, 80, 0, 36)
	controlBar.Position = UDim2.new(1, -92, 1, -48)
	controlBar.BackgroundColor3 = Color3.fromRGB(20, 26, 40)
	controlBar.BorderSizePixel = 0
	controlBar.ZIndex = 15
	controlBar.Visible = false
	controlBar.Parent = group
	makeCorner(controlBar, 8)

	local controlStroke = Instance.new("UIStroke")
	controlStroke.Color = Color3.fromRGB(45, 60, 90)
	controlStroke.Thickness = 1
	controlStroke.Parent = controlBar

	-- Divider between the two buttons
	local divider = Instance.new("Frame")
	divider.Name = "Divider"
	divider.Size = UDim2.new(0, 1, 0, 20)
	divider.Position = UDim2.new(0.5, 0, 0.5, -10)
	divider.BackgroundColor3 = Color3.fromRGB(45, 60, 90)
	divider.BorderSizePixel = 0
	divider.ZIndex = 16
	divider.Parent = controlBar

	-- Reset-view button (left half)
	local resetBtn = Instance.new("TextButton")
	resetBtn.Name = "ResetViewBtn"
	resetBtn.Size = UDim2.new(0.5, -1, 1, 0)
	resetBtn.Position = UDim2.new(0, 0, 0, 0)
	resetBtn.BackgroundTransparency = 1
	resetBtn.Text = "🎯"
	resetBtn.TextSize = 16
	resetBtn.TextColor3 = Color3.fromRGB(150, 180, 240)
	resetBtn.ZIndex = 16
	resetBtn.Parent = controlBar

	resetBtn.MouseEnter:Connect(function()
		resetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	end)
	resetBtn.MouseLeave:Connect(function()
		resetBtn.TextColor3 = Color3.fromRGB(150, 180, 240)
	end)
	resetBtn.MouseButton1Click:Connect(function()
		if self._onResetViewCallback then
			self._onResetViewCallback()
		end
	end)

	-- Snap toggle button (right half)
	self._snapEnabled = false

	local snapBtn = Instance.new("TextButton")
	snapBtn.Name = "SnapBtn"
	snapBtn.Size = UDim2.new(0.5, -1, 1, 0)
	snapBtn.Position = UDim2.new(0.5, 1, 0, 0)
	snapBtn.BackgroundTransparency = 1
	snapBtn.BackgroundColor3 = Color3.fromRGB(65, 78, 105)
	snapBtn.Text = "🧲"
	snapBtn.TextSize = 16
	snapBtn.TextColor3 = Color3.fromRGB(100, 120, 160) -- dimmed = off
	snapBtn.ZIndex = 16
	snapBtn.Parent = controlBar
	makeCorner(snapBtn, 6)

	local snapStroke = Instance.new("UIStroke")
	snapStroke.Color = Color3.fromRGB(90, 110, 150)
	snapStroke.Thickness = 0
	snapStroke.Parent = snapBtn

	local function refreshSnapVisual()
		if self._snapEnabled then
			snapBtn.BackgroundTransparency = 0.25
			snapBtn.TextColor3 = Color3.fromRGB(200, 220, 255)
			snapStroke.Thickness = 1.5
		else
			snapBtn.BackgroundTransparency = 1
			snapBtn.TextColor3 = Color3.fromRGB(100, 120, 160)
			snapStroke.Thickness = 0
		end
	end

	snapBtn.MouseEnter:Connect(function()
		if not self._snapEnabled then
			snapBtn.BackgroundTransparency = 0.85
			snapBtn.TextColor3 = Color3.fromRGB(160, 210, 180)
		end
	end)
	snapBtn.MouseLeave:Connect(function()
		refreshSnapVisual()
	end)
	snapBtn.MouseButton1Click:Connect(function()
		self._snapEnabled = not self._snapEnabled
		refreshSnapVisual()
	end)

	self._controlBar = controlBar
	self._onResetViewCallback = nil

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

	-- Box-selection state
	local boxSelecting = false
	local boxStartPos = nil  -- absolute screen position where drag started
	local selectionBox = nil -- the visual rectangle Frame
	local BOX_DRAG_THRESHOLD = 6 -- pixels before we commit to box-select

	local function createSelectionBox()
		if selectionBox then selectionBox:Destroy() end
		local box = Instance.new("Frame")
		box.Name = "SelectionBox"
		box.BackgroundColor3 = Color3.fromRGB(56, 125, 255)
		box.BackgroundTransparency = 0.80
		box.BorderSizePixel = 0
		box.ZIndex = 20
		box.Parent = self._group

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(100, 170, 255)
		stroke.Thickness = 1.5
		stroke.Parent = box
		
		selectionBox = box
		return box
	end

	local function updateSelectionBox(currentPos)
		if not selectionBox then return end
		local groupPos = self._group.AbsolutePosition
		local x0 = math.min(boxStartPos.X, currentPos.X) - groupPos.X
		local y0 = math.min(boxStartPos.Y, currentPos.Y) - groupPos.Y
		local w  = math.abs(currentPos.X - boxStartPos.X)
		local h  = math.abs(currentPos.Y - boxStartPos.Y)
		selectionBox.Position = UDim2.fromOffset(x0, y0)
		selectionBox.Size     = UDim2.fromOffset(w, h)
		if self._onSelectionBoxDragCallback then
			self._onSelectionBoxDragCallback()
		end
	end

	local function finishSelectionBox(currentPos)
		if not selectionBox then return end
		-- Build rect in absolute screen coords
		local x0 = math.min(boxStartPos.X, currentPos.X)
		local y0 = math.min(boxStartPos.Y, currentPos.Y)
		local x1 = math.max(boxStartPos.X, currentPos.X)
		local y1 = math.max(boxStartPos.Y, currentPos.Y)
		local rect = {
			minX = x0, minY = y0,
			maxX = x1, maxY = y1,
		}
		selectionBox:Destroy()
		selectionBox = nil
		boxSelecting = false
		self.isBoxSelecting = false
		if self._onSelectionBoxCallback then
			self._onSelectionBoxCallback(rect)
		end
	end

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
		mouseInCanvas = true 
	end)
	self._group.MouseLeave:Connect(function() 
		mouseInCanvas = false 
	end)

	self._group.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.MouseButton3 then
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
							self._onRightClickCallback(Vector2.new(input.Position.X, input.Position.Y))
						end
					end
				end
			end)
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			-- Begin potential box-selection
			boxStartPos = input.Position
			boxSelecting = false
			
			local moveConn
			local endConn
			
			moveConn = self._group.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement then return end
				local delta = moveInput.Position - boxStartPos
				if not boxSelecting and delta.Magnitude >= BOX_DRAG_THRESHOLD then
					-- Commit to box-selection (only if no node was hit — caller controls this via isBoxSelecting)
					if not self._suppressBoxSelect then
						boxSelecting = true
						self.isBoxSelecting = true
						createSelectionBox()
					end
				end
				if boxSelecting then
					updateSelectionBox(moveInput.Position)
				end
			end)
			
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					if moveConn then moveConn:Disconnect() end
					endConn:Disconnect()
					
					if boxSelecting then
						finishSelectionBox(input.Position)
					else
						-- It was a plain click (no drag), fire left click callback
						self.isBoxSelecting = false
						if self._onLeftClickCallback then
							self._onLeftClickCallback()
						end
					end
				end
			end)
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
				-- Adjust pan by zoom so dragging feels consistent
				self._panX = startPanX + (delta.X / self._zoom)
				self._panY = startPanY + (delta.Y / self._zoom)
				
				self:_updateLayout()
			end
		elseif input.UserInputType == Enum.UserInputType.MouseWheel then
			local delta = input.Position.Z
			local zoomSpeed = 0.1
			local oldZoom = self._zoom
			
			if delta > 0 then
				self._zoom = math.min(self._zoom + zoomSpeed, 2.0)
			else
				self._zoom = math.max(self._zoom - zoomSpeed, 0.2)
			end
			
			if oldZoom ~= self._zoom then
				self._uiScale.Scale = self._zoom
				if self._gridScale then
					self._gridScale.Scale = self._zoom
				end
				self:_updateLayout()
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, gpe)
		-- In a plugin, gpe is often true just because the widget has focus.
		-- So instead of checking gpe, we check if they're typing in a TextBox.
		if UserInputService:GetFocusedTextBox() then return end
		
		if keys[input.KeyCode] ~= nil then
			keys[input.KeyCode] = true
			--print("[Canvas] Key pressed:", input.KeyCode.Name)
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
			-- Pan speed should probably be adjusted by zoom too
			local speed = PAN_SPEED / self._zoom
			self._panX = self._panX + (dx * speed * dt)
			self._panY = self._panY + (dy * speed * dt)
			
			self:_updateLayout()
		end
	end)
end

function Canvas:_updateLayout()
	self._nodeContainer.Position = UDim2.fromOffset(self._panX * self._zoom, self._panY * self._zoom)
	
	if self._gridFrame then
		local scaledSpacing = DOT_SPACING * self._zoom
		self._gridFrame.Position = UDim2.fromOffset((self._panX * self._zoom) % scaledSpacing, (self._panY * self._zoom) % scaledSpacing)
	end
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
	if self._controlBar then
		self._controlBar.Visible = true
	end

	local gridFrame = Instance.new("Frame")
	gridFrame.Name = "Grid"
	gridFrame.Size = UDim2.new(1, 0, 1, 0)
	gridFrame.BackgroundTransparency = 1
	gridFrame.ZIndex = 1
	gridFrame.Parent = self._group

	local gridScale = Instance.new("UIScale")
	gridScale.Scale = self._zoom
	gridScale.Parent = gridFrame
	self._gridScale = gridScale

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

function Canvas:OnResetView(callback)
	self._onResetViewCallback = callback
end

-- Called when the user finishes a box-selection drag.
-- Callback receives a table: { minX, minY, maxX, maxY } in absolute screen coords.
function Canvas:OnSelectionBox(callback)
	self._onSelectionBoxCallback = callback
end

-- Set to true while a node-drag is happening so we suppress box-select.
function Canvas:SetSuppressBoxSelect(suppress)
	self._suppressBoxSelect = suppress
end

-- Returns true when node-snap is active.
function Canvas:IsSnapEnabled()
	return self._snapEnabled == true
end

-- Returns the snap grid size in canvas units (matches DOT_SPACING).
function Canvas:GetSnapSize()
	return DOT_SPACING
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
	if self._controlBar then
		self._controlBar.Visible = false
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
	-- Since we switched to Frame, we have to recurse or skip if not needed.
	-- However, the user complained about quality, so Frame is necessary.
	-- We'll just leave this as a stub or handle children.
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

function Canvas:GetZoom()
	return self._zoom
end

function Canvas:CenterOnPosition(pos)
	local size = self._group.AbsoluteSize
	self._panX = -pos.X + (size.X / (2 * self._zoom))
	self._panY = -pos.Y + (size.Y / (2 * self._zoom))
	self:_updateLayout()
end

return Canvas