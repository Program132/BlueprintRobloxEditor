-- NodeComment : UE5-style comment box wrapping a group of nodes.
-- Rendered behind nodes (ZIndex 3). Dragging the header moves all contained nodes.

local NodeComment = {}
NodeComment.__index = NodeComment

local PADDING   = 24       -- Space around the tightest bounding box
local HEADER_H  = 28       -- Height of the title bar
local CORNER_R  = 8        -- Border radius

-- Default palette (UE5-ish dark teal)
local DEFAULT_COLOR = Color3.fromRGB(155, 155, 155)

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

-- Compute the bounding box (in canvas / NodeContainer local coords) of a list
-- of NodeComponent objects.
local function computeBounds(nodeComponents)
	local minX, minY =  math.huge,  math.huge
	local maxX, maxY = -math.huge, -math.huge
	for _, vn in ipairs(nodeComponents) do
		local p = vn.frame.Position
		local s = vn.frame.Size
		local x0 = p.X.Offset
		local y0 = p.Y.Offset
		local x1 = x0 + s.X.Offset
		local y1 = y0 + s.Y.Offset
		if x0 < minX then minX = x0 end
		if y0 < minY then minY = y0 end
		if x1 > maxX then maxX = x1 end
		if y1 > maxY then maxY = y1 end
	end
	return minX, minY, maxX, maxY
end

-- ─── Constructor ──────────────────────────────────────────────────────────────
-- nodeComponents  : array of NodeComponent objects currently selected
-- canvasContainer : canvas:GetNodeContainer() (Frame that holds all nodes)
-- canvasRef       : the Canvas object (for zoom / pan helpers)
-- label           : initial comment string (optional)
-- color           : Color3 for the header (optional)
function NodeComment.new(nodeComponents, canvasContainer, canvasRef, label, color)
	local self = setmetatable({}, NodeComment)

	self._containedNodes = {} -- snapshot of nodes inside this comment
	for _, vn in ipairs(nodeComponents) do
		table.insert(self._containedNodes, vn)
	end

	self._canvas = canvasRef
	self._label  = label or "Comment"
	self._color  = color or DEFAULT_COLOR

	-- Compute bounds in local node-container coords
	local minX, minY, maxX, maxY = computeBounds(self._containedNodes)
	local x = minX - PADDING
	local y = minY - PADDING - HEADER_H
	local w = (maxX - minX) + PADDING * 2
	local h = (maxY - minY) + PADDING * 2 + HEADER_H

	-- Root frame (body)
	local frame = Instance.new("Frame")
	frame.Name = "Comment"
	frame.Position = UDim2.fromOffset(x, y)
	frame.Size     = UDim2.fromOffset(w, h)
	frame.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	frame.BackgroundTransparency = 0.55
	frame.BorderSizePixel = 0
	frame.ZIndex = 3
	frame.Parent = canvasContainer
	makeCorner(frame, CORNER_R)

	local bodyStroke = Instance.new("UIStroke")
	bodyStroke.Color = Color3.fromRGB(15, 20, 30) -- Subtle dark
	bodyStroke.Thickness = 1.5
	bodyStroke.Parent = frame
	self._bodyStroke = bodyStroke

	-- Header bar
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, HEADER_H)
	header.Position = UDim2.fromOffset(0, 0)
	header.BackgroundColor3 = self._color
	header.BorderSizePixel = 0
	header.ZIndex = 4
	header.Active = true
	header.Parent = frame
	makeCorner(header, CORNER_R)

	-- Square off the bottom corners of the header
	local headerSq = Instance.new("Frame")
	headerSq.Size = UDim2.new(1, 0, 0, CORNER_R)
	headerSq.Position = UDim2.new(0, 0, 1, -CORNER_R)
	headerSq.BackgroundColor3 = self._color
	headerSq.BorderSizePixel = 0
	headerSq.ZIndex = 4
	headerSq.Parent = header

	-- Comment label (read-only display)
	local labelDisplay = Instance.new("TextLabel")
	labelDisplay.Name = "LabelDisplay"
	labelDisplay.Size = UDim2.new(1, -12, 1, 0)
	labelDisplay.Position = UDim2.fromOffset(10, 0)
	labelDisplay.BackgroundTransparency = 1
	labelDisplay.Text = self._label
	labelDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
	labelDisplay.TextSize = 13
	labelDisplay.Font = Enum.Font.GothamBold
	labelDisplay.TextXAlignment = Enum.TextXAlignment.Left
	labelDisplay.TextTruncate = Enum.TextTruncate.AtEnd
	labelDisplay.ZIndex = 5
	labelDisplay.Parent = header
	self._labelDisplay = labelDisplay

	-- Inline text-box for editing (hidden by default)
	local editBox = Instance.new("TextBox")
	editBox.Name = "EditBox"
	editBox.Size = UDim2.new(1, -12, 1, -4)
	editBox.Position = UDim2.fromOffset(8, 2)
	editBox.BackgroundColor3 = Color3.fromRGB(10, 14, 22)
	editBox.BorderSizePixel = 0
	editBox.Text = self._label
	editBox.PlaceholderText = "Comment..."
	editBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	editBox.TextSize = 13
	editBox.Font = Enum.Font.GothamBold
	editBox.TextXAlignment = Enum.TextXAlignment.Left
	editBox.ClearTextOnFocus = false
	editBox.ZIndex = 6
	editBox.Visible = false
	editBox.Parent = header
	makeCorner(editBox, 4)
	self._editBox = editBox

	-- Commit edit when the TextBox loses focus
	editBox.FocusLost:Connect(function()
		self._label = editBox.Text ~= "" and editBox.Text or self._label
		labelDisplay.Text = self._label
		editBox.Visible = false
		labelDisplay.Visible = true
	end)

	-- Double-click the header → enter edit mode
	local lastClickTime = 0
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local now = tick()
			if (now - lastClickTime) < 0.35 then
				-- Double-click: open editor
				labelDisplay.Visible = false
				editBox.Visible = true
				editBox:CaptureFocus()
				editBox.CursorPosition = #editBox.Text + 1
			end
			lastClickTime = now
		end
	end)

	self.frame  = frame
	self.header = header
	self.selected = false

	self.OnSelect  = Instance.new("BindableEvent")
	self.OnKeyDown = Instance.new("BindableEvent")

	self:_makeDraggable()

	-- Hover: highlight border
	frame.MouseEnter:Connect(function()
		if not self.selected then
			bodyStroke.Color = Color3.fromRGB(60, 80, 110)
			bodyStroke.Thickness = 2
		end
	end)
	frame.MouseLeave:Connect(function()
		if not self.selected then
			bodyStroke.Color = Color3.fromRGB(15, 20, 30)
			bodyStroke.Thickness = 1.5
		end
	end)

	-- Key events bubble from the comment frame
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			self.OnKeyDown:Fire(input.KeyCode)
		end
	end)
	header.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			self.OnKeyDown:Fire(input.KeyCode)
		end
	end)

	return self
end

-- ─── Dragging ─────────────────────────────────────────────────────────────────
function NodeComment:_makeDraggable()
	local dragging   = false
	local dragStart  = nil
	local startFrame = nil
	-- Snapshot of contained-node start positions
	local startNodePositions = {}

	self.header.InputBegan:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

		-- Don't start drag while editing text
		if self._editBox.Visible then return end

		dragging   = true
		dragStart  = input.Position
		startFrame = self.frame.Position
		startNodePositions = {}
		for _, vn in ipairs(self._containedNodes) do
			startNodePositions[vn] = vn.frame.Position
		end

		self:Select()
		self.OnSelect:Fire()

		if self._canvas then
			self._canvas:SetSuppressBoxSelect(true)
		end

		local endConn, dragConn

		endConn = input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
				startNodePositions = {}
				if self._canvas then
					self._canvas:SetSuppressBoxSelect(false)
				end
				if dragConn then dragConn:Disconnect(); dragConn = nil end
				endConn:Disconnect()
			end
		end)

		local canvasFrame = self.frame.Parent and self.frame.Parent.Parent
		if canvasFrame and canvasFrame:IsA("GuiObject") then
			dragConn = canvasFrame.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement then return end
				if not dragging then return end

				local zoom = 1
				local uiScale = self.frame.Parent and self.frame.Parent:FindFirstChildOfClass("UIScale")
				if uiScale then zoom = uiScale.Scale end

				local snapSize = self._canvas and self._canvas:IsSnapEnabled() and self._canvas:GetSnapSize() or nil
				local function snapVal(v)
					if snapSize then
						return math.round(v / snapSize) * snapSize
					end
					return v
				end

				local delta = moveInput.Position - dragStart
				local dx = delta.X / zoom
				local dy = delta.Y / zoom

				-- Move the comment frame
				self.frame.Position = UDim2.fromOffset(
					snapVal(startFrame.X.Offset + dx),
					snapVal(startFrame.Y.Offset + dy)
				)

				-- Move all contained nodes by the same delta
				for vn, sPos in pairs(startNodePositions) do
					local newX = snapVal(sPos.X.Offset + dx)
					local newY = snapVal(sPos.Y.Offset + dy)
					vn.frame.Position = UDim2.new(0, newX, 0, newY)
					vn.nodeData:editPosition(Vector2.new(newX, newY))
				end
			end)
		end
	end)
end

-- ─── Selection ────────────────────────────────────────────────────────────────
function NodeComment:Select()
	self.selected = true
	self._bodyStroke.Color = Color3.fromRGB(200, 220, 255)
	self._bodyStroke.Thickness = 2.5
end

function NodeComment:Deselect()
	self.selected = false
	self._bodyStroke.Color = Color3.fromRGB(15, 20, 30)
	self._bodyStroke.Thickness = 1.5
end

-- ─── Cleanup ──────────────────────────────────────────────────────────────────
function NodeComment:Destroy()
	if self.OnSelect  then self.OnSelect:Destroy()  end
	if self.OnKeyDown then self.OnKeyDown:Destroy() end
	if self.frame     then self.frame:Destroy()     end
end

-- ─── Accessors ────────────────────────────────────────────────────────────────
function NodeComment:GetContainedNodes()
	return self._containedNodes
end

function NodeComment:GetLabel()
	return self._label
end

return NodeComment
