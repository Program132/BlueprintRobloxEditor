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

	return self
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

	local cols = math.min(math.ceil(absSize.X / DOT_SPACING) + 1, 80)
	local rows = math.min(math.ceil(absSize.Y / DOT_SPACING) + 1, 60)

	for row = 0, rows do
		for col = 0, cols do
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

return Canvas