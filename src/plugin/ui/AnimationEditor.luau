local _HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ChoiceModal = require(script.Parent.ChoiceModal)
local Modal = require(script.Parent.Modal)

local AnimationEditor = {}
AnimationEditor.__index = AnimationEditor

-- Colors consistent with design system
local PANEL_BG = Color3.fromRGB(16, 21, 34)
local BORDER_COLOR = Color3.fromRGB(38, 50, 72)
local TEXT_COLOR = Color3.fromRGB(170, 195, 230)
local VIEWPORT_BG = Color3.fromRGB(10, 12, 20)
local ACCENT_COLOR = Color3.fromRGB(45, 130, 240)
local _KEYFRAME_COLOR = Color3.fromRGB(0, 220, 200)
local SELECTED_KEYFRAME_COLOR = Color3.fromRGB(255, 200, 50)

local CLASS_ICONS = {
	Frame = "🔲", ScrollingFrame = "📜", TextLabel = "🔤",
	TextButton = "🔘", TextBox = "✍️", ImageLabel = "🖼️", ImageButton = "🖼️🔘"
}

local ANIMATABLE_PROPERTIES = {
	"Position", "Size", "BackgroundColor3", "BackgroundTransparency",
	"Rotation", "TextColor3", "TextTransparency", "ImageColor3", "ImageTransparency"
}

local TRACK_COLORS = {
	Position = Color3.fromRGB(80, 140, 240),               -- Light Blue
	Size = Color3.fromRGB(75, 190, 110),                   -- Green
	Rotation = Color3.fromRGB(245, 210, 60),               -- Yellow
	BackgroundColor3 = Color3.fromRGB(245, 150, 60),       -- Orange
	TextColor3 = Color3.fromRGB(245, 150, 60),             -- Orange
	ImageColor3 = Color3.fromRGB(245, 150, 60),            -- Orange
	BackgroundTransparency = Color3.fromRGB(200, 70, 200), -- Magenta
	TextTransparency = Color3.fromRGB(200, 70, 200),       -- Magenta
	ImageTransparency = Color3.fromRGB(200, 70, 200),      -- Magenta
}

local DEFAULT_PROPERTIES = {
	Frame = {
		Size = {0.15, 0, 0.2, 0}, Position = {0, 0, 0, 0}, AnchorPoint = {0, 0},
		BackgroundColor3 = {30, 40, 55}, BackgroundTransparency = 0, Rotation = 0, Visible = true
	},
	ScrollingFrame = {
		Size = {0.15, 0, 0.2, 0}, Position = {0, 0, 0, 0}, AnchorPoint = {0, 0},
		BackgroundColor3 = {30, 40, 55}, BackgroundTransparency = 0, Rotation = 0, Visible = true
	},
	TextLabel = {
		Size = {0.15, 0, 0.05, 0}, Position = {0, 0, 0, 0}, AnchorPoint = {0, 0},
		BackgroundColor3 = {35, 45, 65}, BackgroundTransparency = 0, Rotation = 0, Visible = true,
		TextColor3 = {240, 240, 240}, TextTransparency = 0
	},
	TextButton = {
		Size = {0.12, 0, 0.05, 0}, Position = {0, 0, 0, 0}, AnchorPoint = {0, 0},
		BackgroundColor3 = {45, 90, 160}, BackgroundTransparency = 0, Rotation = 0, Visible = true,
		TextColor3 = {255, 255, 255}, TextTransparency = 0
	},
	TextBox = {
		Size = {0.12, 0, 0.05, 0}, Position = {0, 0, 0, 0}, AnchorPoint = {0, 0},
		BackgroundColor3 = {20, 25, 35}, BackgroundTransparency = 0, Rotation = 0, Visible = true,
		TextColor3 = {240, 240, 240}, TextTransparency = 0
	},
	ImageLabel = {
		Size = {0.12, 0, 0.15, 0}, Position = {0, 0, 0, 0}, AnchorPoint = {0, 0},
		BackgroundColor3 = {255, 255, 255}, BackgroundTransparency = 0, Rotation = 0, Visible = true,
		ImageColor3 = {255, 255, 255}, ImageTransparency = 0
	},
	ImageButton = {
		Size = {0.12, 0, 0.15, 0}, Position = {0, 0, 0, 0}, AnchorPoint = {0, 0},
		BackgroundColor3 = {255, 255, 255}, BackgroundTransparency = 0, Rotation = 0, Visible = true,
		ImageColor3 = {255, 255, 255}, ImageTransparency = 0
	}
}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function makeBorder(parent)
	local stroke = Instance.new("UIStroke")
	stroke.Color = BORDER_COLOR
	stroke.Thickness = 1
	stroke.Parent = parent
	return stroke
end

local function findParentAndIndex(elements, targetId)
	for i, el in ipairs(elements) do
		if el.id == targetId then
			return elements, i
		end
		if el.children then
			local p, idx = findParentAndIndex(el.children, targetId)
			if p then return p, idx end
		end
	end
	return nil, nil
end

local function getElementProperty(el, prop)
	if el.properties and el.properties[prop] ~= nil then
		return el.properties[prop]
	end
	local defaults = DEFAULT_PROPERTIES[el.class]
	if defaults and defaults[prop] ~= nil then
		return defaults[prop]
	end
	if prop == "Position" or prop == "Size" then return {0, 0, 0, 0}
	elseif prop == "BackgroundColor3" or prop == "TextColor3" or prop == "ImageColor3" then return {255, 255, 255}
	elseif prop:find("Transparency") then return 0
	elseif prop == "Rotation" then return 0
	end
	return 0
end

local function lerpValue(v1, v2, alpha, prop)
	if typeof(v1) == "table" then
		if #v1 == 4 then
			local sx = v1[1] + (v2[1] - v1[1]) * alpha
			local ox = v1[2] + (v2[2] - v1[2]) * alpha
			local sy = v1[3] + (v2[3] - v1[3]) * alpha
			local oy = v1[4] + (v2[4] - v1[4]) * alpha
			return {sx, ox, sy, oy}
		elseif #v1 == 2 then
			local s = v1[1] + (v2[1] - v1[1]) * alpha
			local o = v1[2] + (v2[2] - v1[2]) * alpha
			return {s, o}
		elseif #v1 == 3 then
			local r = math.round(v1[1] + (v2[1] - v1[1]) * alpha)
			local g = math.round(v1[2] + (v2[2] - v1[2]) * alpha)
			local b = math.round(v1[3] + (v2[3] - v1[3]) * alpha)
			return {r, g, b}
		end
	elseif typeof(v1) == "number" then
		return v1 + (v2 - v1) * alpha
	end
	return v2
end

local function cloneValue(v)
	if typeof(v) == "table" then
		local c = {}
		for k, val in pairs(v) do
			c[k] = val
		end
		return c
	end
	return v
end

local function evaluateTrack(track, time)
	local keyframes = track.keyframes
	if not keyframes or #keyframes == 0 then return nil end

	-- Sort keyframes copy by time
	local kfs = {}
	for _, kf in ipairs(keyframes) do table.insert(kfs, kf) end
	table.sort(kfs, function(a, b) return a.time < b.time end)

	if #kfs == 1 then
		return kfs[1].value
	end

	if time <= kfs[1].time then
		return kfs[1].value
	end

	if time >= kfs[#kfs].time then
		return kfs[#kfs].value
	end

	for i = 1, #kfs - 1 do
		local kf1 = kfs[i]
		local kf2 = kfs[i+1]
		if time >= kf1.time and time <= kf2.time then
			local alpha = (time - kf1.time) / (kf2.time - kf1.time)
			local easedAlpha = alpha
			local style = kf1.easingStyle or "Linear"
			local dir = kf1.easingDirection or "Out"

			local ok, res = pcall(function()
				return game:GetService("TweenService"):GetValue(alpha, Enum.EasingStyle[style], Enum.EasingDirection[dir])
			end)
			if ok then easedAlpha = res end

			return lerpValue(kf1.value, kf2.value, easedAlpha, track.property)
		end
	end

	return kfs[#kfs].value
end

local function getAnimatedOrBaseProperty(self, elementName, propertyName, baseVal)
	if self._activeAnimation then
		for _, track in ipairs(self._activeAnimation.tracks or {}) do
			if track.elementName == elementName and track.property == propertyName then
				local val = evaluateTrack(track, self._currentTime)
				if val ~= nil then return val end
			end
		end
	end
	return baseVal
end

local function getVirtualParentSize(self, el)
	local plist, _ = findParentAndIndex(self._uiElements, el.id)
	if plist == self._uiElements then
		return self._viewportMockup.AbsoluteSize
	end
	
	local parentEl = nil
	local function findParentEl(list)
		for _, item in ipairs(list) do
			if item.children then
				for _, child in ipairs(item.children) do
					if child.id == el.id then
						parentEl = item
						return
					end
				end
				findParentEl(item.children)
			end
		end
	end
	findParentEl(self._uiElements)
	
	if parentEl then
		local inst = self._viewportInstances[parentEl.name]
		if inst then
			return inst.AbsoluteSize
		end
	end
	return self._viewportMockup.AbsoluteSize
end

local function getElementVirtualPixelSize(self, el)
	local curSize = getAnimatedOrBaseProperty(self, el.name, "Size", el.properties.Size or {0, 100, 0, 100})
	local parentSize = getVirtualParentSize(self, el)
	local w = curSize[1] * parentSize.X + curSize[2]
	local h = curSize[3] * parentSize.Y + curSize[4]
	return Vector2.new(w, h)
end

local function _getElementVirtualPixelPos(self, el)
	local curPos = getAnimatedOrBaseProperty(self, el.name, "Position", el.properties.Position or {0, 0, 0, 0})
	local parentSize = getVirtualParentSize(self, el)
	local x = curPos[1] * parentSize.X + curPos[2]
	local y = curPos[3] * parentSize.Y + curPos[4]
	return Vector2.new(x, y)
end

local function getElementMockupRelativePos(self, el)
	local curPos = getAnimatedOrBaseProperty(self, el.name, "Position", el.properties.Position or {0, 0, 0, 0})
	local parentSize = getVirtualParentSize(self, el)
	local localX = curPos[1] * parentSize.X + curPos[2]
	local localY = curPos[3] * parentSize.Y + curPos[4]

	local curAnchor = el.properties.AnchorPoint or {0, 0}
	local elSize = getElementVirtualPixelSize(self, el)
	local localTopLeftX = localX - curAnchor[1] * elSize.X
	local localTopLeftY = localY - curAnchor[2] * elSize.Y

	local plist, _ = findParentAndIndex(self._uiElements, el.id)
	if plist == self._uiElements then
		return Vector2.new(localTopLeftX, localTopLeftY)
	end

	local parentEl = nil
	local function findParentEl(list)
		for _, item in ipairs(list) do
			if item.children then
				for _, child in ipairs(item.children) do
					if child.id == el.id then
						parentEl = item
						return
					end
				end
				findParentEl(item.children)
			end
		end
	end
	findParentEl(self._uiElements)

	if parentEl then
		return getElementMockupRelativePos(self, parentEl) + Vector2.new(localTopLeftX, localTopLeftY)
	end
	return Vector2.new(localTopLeftX, localTopLeftY)
end

local function showSnapLine(self, axis, position)
	if not self._viewportMockup then return end
	local lineName = "SnapLine" .. axis
	local line = self._viewportMockup:FindFirstChild(lineName)
	if not line then
		line = Instance.new("Frame")
		line.Name = lineName
		line.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
		line.BorderSizePixel = 0
		line.ZIndex = 999
		line.BackgroundTransparency = 0.3
		line.Parent = self._viewportMockup
	end

	if axis == "X" then
		line.Size = UDim2.new(0, 1, 1, 0)
		line.Position = UDim2.new(0, position, 0, 0)
	else
		line.Size = UDim2.new(1, 0, 0, 1)
		line.Position = UDim2.new(0, 0, 0, position)
	end
	line.Visible = true
end

local function hideSnapLine(self, axis)
	if not self._viewportMockup then return end
	local line = self._viewportMockup:FindFirstChild("SnapLine" .. axis)
	if line then
		line.Visible = false
	end
end

function AnimationEditor.new(parent)
	local self = setmetatable({}, AnimationEditor)

	self._parent = parent
	self._sData = nil
	self._uiElements = {}
	self._animations = {}
	self._activeAnimation = nil
	self._selectedElement = nil
	self._selectedTrack = nil
	self._selectedKeyframe = nil
	self._currentTime = 0.0
	self._playing = false
	self._viewportInstances = {}
	self._snappingEnabled = true

	-- Drag & Resize State
	self._isDragging = false
	self._draggedElement = nil
	self._draggedInstance = nil
	self._dragStartMousePos = nil
	self._dragStartElementPos = nil

	self._isResizing = false
	self._resizedElement = nil
	self._resizedInstance = nil
	self._resizeStartMousePos = nil
	self._resizeStartElementSize = nil
	self._resizeStartElementPos = nil
	self._resizeHandleType = nil

	-- Main Layout
	local mainFrame = Instance.new("Frame")
	mainFrame.Name = "AnimationEditorFrame"
	mainFrame.Size = UDim2.new(1, 0, 1, 0)
	mainFrame.BackgroundColor3 = PANEL_BG
	mainFrame.BorderSizePixel = 0
	mainFrame.Visible = false
	mainFrame.Parent = parent
	self._frame = mainFrame

	-- Hidden TextBox to capture keyboard focus for shortcuts
	local keyboardCapture = Instance.new("TextBox")
	keyboardCapture.Name = "KeyboardCapture"
	keyboardCapture.Size = UDim2.fromOffset(1, 1)
	keyboardCapture.Position = UDim2.new(0, -10, 0, -10) -- offscreen
	keyboardCapture.BackgroundTransparency = 1
	keyboardCapture.Text = ""
	keyboardCapture.PlaceholderText = ""
	keyboardCapture.ClearTextOnFocus = false
	keyboardCapture.Parent = mainFrame
	self._keyboardCapture = keyboardCapture

	-- When text changes, clear it so it doesn't build up
	keyboardCapture:GetPropertyChangedSignal("Text"):Connect(function()
		if keyboardCapture.Text ~= "" then
			keyboardCapture.Text = ""
		end
	end)

	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 then
			local focused = UserInputService:GetFocusedTextBox()
			if not focused or (focused ~= keyboardCapture and (focused.Parent.Name ~= "RightPanel" and focused.Parent.Parent.Name ~= "RightPanel")) then
				keyboardCapture:CaptureFocus()
			end
		end
	end)

	-- Grid layout structure
	-- ── Left Panel (Hierarchy) ────────────────────────────────────────────────
	local leftPanel = Instance.new("Frame")
	leftPanel.Name = "LeftPanel"
	leftPanel.Size = UDim2.new(0.24, -10, 0.6, -10)
	leftPanel.Position = UDim2.new(0, 8, 0, 8)
	leftPanel.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	leftPanel.BorderSizePixel = 0
	leftPanel.Parent = mainFrame
	makeCorner(leftPanel, 6)
	makeBorder(leftPanel)

	local leftTitle = Instance.new("TextLabel")
	leftTitle.Size = UDim2.new(1, 0, 0, 24)
	leftTitle.BackgroundTransparency = 1
	leftTitle.Text = "  UI Hierarchy"
	leftTitle.TextColor3 = Color3.fromRGB(250, 250, 250)
	leftTitle.TextSize = 11
	leftTitle.Font = Enum.Font.GothamBold
	leftTitle.TextXAlignment = Enum.TextXAlignment.Left
	leftTitle.Parent = leftPanel

	local hierarchyScroll = Instance.new("ScrollingFrame")
	hierarchyScroll.Name = "HierarchyScroll"
	hierarchyScroll.Size = UDim2.new(1, -8, 1, -32)
	hierarchyScroll.Position = UDim2.new(0, 4, 0, 28)
	hierarchyScroll.BackgroundTransparency = 1
	hierarchyScroll.BorderSizePixel = 0
	hierarchyScroll.ScrollBarThickness = 4
	hierarchyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	hierarchyScroll.Parent = leftPanel
	self._hierarchyScroll = hierarchyScroll

	local hLayout = Instance.new("UIListLayout")
	hLayout.SortOrder = Enum.SortOrder.LayoutOrder
	hLayout.Padding = UDim.new(0, 2)
	hLayout.Parent = hierarchyScroll

	-- ── Viewport Mockup (Center) ────────────────────────────────────────────────
	local viewportFrame = Instance.new("Frame")
	viewportFrame.Name = "ViewportFrame"
	viewportFrame.Size = UDim2.new(0.52, -12, 0.6, -10)
	viewportFrame.Position = UDim2.new(0.24, 6, 0, 8)
	viewportFrame.BackgroundColor3 = VIEWPORT_BG
	viewportFrame.BorderSizePixel = 0
	viewportFrame.Parent = mainFrame
	makeCorner(viewportFrame, 6)
	makeBorder(viewportFrame)

	local viewportLabel = Instance.new("TextLabel")
	viewportLabel.Name = "ViewportLabel"
	viewportLabel.Size = UDim2.new(1, -16, 0, 20)
	viewportLabel.Position = UDim2.new(0, 8, 0, 4)
	viewportLabel.BackgroundTransparency = 1
	viewportLabel.Text = "ANIMATION PREVIEW MOCKUP"
	viewportLabel.TextColor3 = Color3.fromRGB(60, 80, 110)
	viewportLabel.TextSize = 10
	viewportLabel.Font = Enum.Font.GothamBold
	viewportLabel.ZIndex = 5
	viewportLabel.Parent = viewportFrame

	local viewportMockup = Instance.new("Frame")
	viewportMockup.Name = "Mockup"
	viewportMockup.Size = UDim2.new(1, -32, 1, -44)
	viewportMockup.Position = UDim2.new(0, 16, 0, 28)
	viewportMockup.BackgroundColor3 = Color3.fromRGB(30, 35, 45)
	viewportMockup.BorderSizePixel = 0
	viewportMockup.ClipsDescendants = true
	viewportMockup.Parent = viewportFrame
	self._viewportMockup = viewportMockup
	makeCorner(viewportMockup, 4)

	-- ── Controls Panel (Right) ────────────────────────────────────────────────
	local rightPanel = Instance.new("Frame")
	rightPanel.Name = "RightPanel"
	rightPanel.Size = UDim2.new(0.24, -10, 0.6, -10)
	rightPanel.Position = UDim2.new(0.76, 2, 0, 8)
	rightPanel.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	rightPanel.BorderSizePixel = 0
	rightPanel.Parent = mainFrame
	makeCorner(rightPanel, 6)
	makeBorder(rightPanel)

	-- Details/Animator Label
	local detailsTitle = Instance.new("TextLabel")
	detailsTitle.Size = UDim2.new(0.4, 0, 0, 30)
	detailsTitle.Position = UDim2.new(0, 12, 0, 0)
	detailsTitle.BackgroundTransparency = 1
	detailsTitle.Text = "ANIMATOR"
	detailsTitle.TextColor3 = TEXT_COLOR
	detailsTitle.TextSize = 11
	detailsTitle.Font = Enum.Font.GothamBold
	detailsTitle.TextXAlignment = Enum.TextXAlignment.Left
	detailsTitle.Parent = rightPanel

	-- Snapping Toggle Button (matching Design tab look and functionality)
	local snapToggle = Instance.new("TextButton")
	snapToggle.Name = "SnapToggle"
	snapToggle.Size = UDim2.new(0, 50, 0, 20)
	snapToggle.Position = UDim2.new(1, -62, 0, 5)
	snapToggle.BackgroundColor3 = Color3.fromRGB(38, 70, 120)
	snapToggle.BorderSizePixel = 0
	snapToggle.Text = "Snap"
	snapToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	snapToggle.TextSize = 10
	snapToggle.Font = Enum.Font.GothamBold
	makeCorner(snapToggle, 4)
	makeBorder(snapToggle)
	snapToggle.Parent = rightPanel
	self._snapToggle = snapToggle

	snapToggle.MouseButton1Click:Connect(function()
		self._snappingEnabled = not self._snappingEnabled
		if self._snappingEnabled then
			snapToggle.BackgroundColor3 = Color3.fromRGB(38, 70, 120)
			snapToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
			snapToggle.Font = Enum.Font.GothamBold
		else
			snapToggle.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
			snapToggle.TextColor3 = Color3.fromRGB(130, 150, 180)
			snapToggle.Font = Enum.Font.GothamMedium
		end
	end)

	local rightScroll = Instance.new("ScrollingFrame")
	rightScroll.Size = UDim2.new(1, -10, 1, -35)
	rightScroll.Position = UDim2.new(0, 5, 0, 30)
	rightScroll.BackgroundTransparency = 1
	rightScroll.BorderSizePixel = 0
	rightScroll.ScrollBarThickness = 4
	rightScroll.CanvasSize = UDim2.new(0, 0, 1.25, 0)
	rightScroll.Parent = rightPanel

	local rLayout = Instance.new("UIListLayout")
	rLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rLayout.Padding = UDim.new(0, 8)
	rLayout.Parent = rightScroll
	self._rightScroll = rightScroll

	-- ── Timeline Scrubber (Bottom) ───────────────────────────────────────────
	local timelinePanel = Instance.new("Frame")
	timelinePanel.Name = "TimelinePanel"
	timelinePanel.Size = UDim2.new(1, -16, 0.4, -14)
	timelinePanel.Position = UDim2.new(0, 8, 0.6, 2)
	timelinePanel.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	timelinePanel.BorderSizePixel = 0
	timelinePanel.Parent = mainFrame
	makeCorner(timelinePanel, 6)
	makeBorder(timelinePanel)
	self._timelinePanel = timelinePanel

	-- Scrubber header (for time markers + playhead)
	local timelineHeader = Instance.new("Frame")
	timelineHeader.Name = "Header"
	timelineHeader.Size = UDim2.new(1, 0, 0, 28)
	timelineHeader.BackgroundColor3 = Color3.fromRGB(18, 24, 38)
	timelineHeader.BorderSizePixel = 0
	timelineHeader.Parent = timelinePanel

	-- Animation dropdown select button in the header empty space
	local animSelectBtn = Instance.new("TextButton")
	animSelectBtn.Name = "AnimSelectBtn"
	animSelectBtn.Size = UDim2.new(0, 160, 0, 20)
	animSelectBtn.Position = UDim2.new(0, 8, 0.5, -10)
	animSelectBtn.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
	animSelectBtn.BorderSizePixel = 0
	animSelectBtn.Text = "🎬 Select Anim..."
	animSelectBtn.TextColor3 = TEXT_COLOR
	animSelectBtn.TextSize = 10
	animSelectBtn.Font = Enum.Font.GothamBold
	animSelectBtn.Parent = timelineHeader
	makeCorner(animSelectBtn, 4)
	makeBorder(animSelectBtn)
	self._animSelectBtn = animSelectBtn

	animSelectBtn.MouseButton1Click:Connect(function()
		local animNames = {}
		for _, a in ipairs(self._animations) do
			table.insert(animNames, a.name)
		end
		if #animNames == 0 then return end
		ChoiceModal.prompt(self._frame, "Select Animation", animNames, function(choice)
			for _, a in ipairs(self._animations) do
				if a.name == choice then
					self._activeAnimation = a
					self._selectedTrack = nil
					self._selectedKeyframe = nil
					self._currentTime = 0.0
					self:refreshAll()
					break
				end
			end
		end)
	end)

	local playheadLine = Instance.new("Frame")
	playheadLine.Name = "Playhead"
	playheadLine.Size = UDim2.new(0, 2, 1, 0)
	playheadLine.BackgroundColor3 = Color3.fromRGB(240, 80, 80)
	playheadLine.BorderSizePixel = 0
	playheadLine.ZIndex = 50
	playheadLine.Parent = timelinePanel
	self._playheadLine = playheadLine

	local timelineScroll = Instance.new("ScrollingFrame")
	timelineScroll.Name = "TracksScroll"
	timelineScroll.Size = UDim2.new(1, -8, 1, -32)
	timelineScroll.Position = UDim2.new(0, 4, 0, 30)
	timelineScroll.BackgroundTransparency = 1
	timelineScroll.BorderSizePixel = 0
	timelineScroll.ScrollBarThickness = 6
	timelineScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	timelineScroll.Parent = timelinePanel
	self._timelineScroll = timelineScroll

	local tLayout = Instance.new("UIListLayout")
	tLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tLayout.Padding = UDim.new(0, 2)
	tLayout.Parent = timelineScroll

	self:buildControls()

	-- Interactive Drag & Resize connection connected directly to mainFrame
	mainFrame.InputChanged:Connect(function(input)
		if not mainFrame.Visible then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local scale = 1 
			
			if self._isDragging and self._draggedElement then
				local mousePos = input.Position
				local delta = (mousePos - self._dragStartMousePos) / scale
				
				if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
					if math.abs(delta.X) > math.abs(delta.Y) then
						delta = Vector2.new(delta.X, 0)
					else
						delta = Vector2.new(0, delta.Y)
					end
				end
				
				local newX = self._dragStartElementPos.X + delta.X
				local newY = self._dragStartElementPos.Y + delta.Y
				
				local el = self._draggedElement
				local parentSize = getVirtualParentSize(self, el)
				local curSize = getAnimatedOrBaseProperty(self, el.name, "Size", el.properties.Size or {0, 100, 0, 100})
				local w = curSize[1] * parentSize.X + curSize[2]
				local h = curSize[3] * parentSize.Y + curSize[4]
				local elSize = Vector2.new(w, h)
				local anchor = el.properties.AnchorPoint or {0, 0}
				
				-- Apply Drag Snapping
				local visualX = newX - anchor[1] * elSize.X
				local visualY = newY - anchor[2] * elSize.Y
				local snappedX = false
				local snappedY = false

				if self._snappingEnabled then
					local threshold = 12
					local parentMockupPos = Vector2.new(0, 0)
					local plist, _index = findParentAndIndex(self._uiElements, el.id)
					if plist ~= self._uiElements then
						local parentEl = nil
						local function findParentEl(list)
							for _, item in ipairs(list) do
								if item.children then
									for _, child in ipairs(item.children) do
										if child.id == el.id then
											parentEl = item
											return
										end
									end
									findParentEl(item.children)
								end
							end
						end
						findParentEl(self._uiElements)
						if parentEl then
							parentMockupPos = getElementMockupRelativePos(self, parentEl)
						end
					end

					local xTargets = {}
					local yTargets = {}

					-- 1. Parent snap coordinates
					table.insert(xTargets, parentMockupPos.X)
					table.insert(xTargets, parentMockupPos.X + parentSize.X / 2)
					table.insert(xTargets, parentMockupPos.X + parentSize.X)
					table.insert(yTargets, parentMockupPos.Y)
					table.insert(yTargets, parentMockupPos.Y + parentSize.Y / 2)
					table.insert(yTargets, parentMockupPos.Y + parentSize.Y)

					-- 2. Mockup hierarchy snap targets
					local function addTargets(list)
						for _, otherEl in ipairs(list) do
							if otherEl.id ~= el.id then
								local otherMockupPos = getElementMockupRelativePos(self, otherEl)
								local otherSize = getElementVirtualPixelSize(self, otherEl)

								table.insert(xTargets, otherMockupPos.X)
								table.insert(xTargets, otherMockupPos.X + otherSize.X / 2)
								table.insert(xTargets, otherMockupPos.X + otherSize.X)

								table.insert(yTargets, otherMockupPos.Y)
								table.insert(yTargets, otherMockupPos.Y + otherSize.Y / 2)
								table.insert(yTargets, otherMockupPos.Y + otherSize.Y)

								if otherEl.children then
									addTargets(otherEl.children)
								end
							end
						end
					end
					addTargets(self._uiElements)

					local mockupTopLeft = parentMockupPos + Vector2.new(visualX, visualY)

					-- Find best X Snap alignment
					local bestDiffX = threshold
					local bestTargetX = nil
					local snapTypeX = nil

					for _, targetX in ipairs(xTargets) do
						local diffL = math.abs(mockupTopLeft.X - targetX)
						if diffL < bestDiffX then
							bestDiffX = diffL
							bestTargetX = targetX
							snapTypeX = "left"
						end
						local diffC = math.abs((mockupTopLeft.X + elSize.X / 2) - targetX)
						if diffC < bestDiffX then
							bestDiffX = diffC
							bestTargetX = targetX
							snapTypeX = "center"
						end
						local diffR = math.abs((mockupTopLeft.X + elSize.X) - targetX)
						if diffR < bestDiffX then
							bestDiffX = diffR
							bestTargetX = targetX
							snapTypeX = "right"
						end
					end

					if bestTargetX then
						snappedX = true
						if snapTypeX == "left" then
							visualX = bestTargetX - parentMockupPos.X
						elseif snapTypeX == "center" then
							visualX = (bestTargetX - elSize.X / 2) - parentMockupPos.X
						elseif snapTypeX == "right" then
							visualX = (bestTargetX - elSize.X) - parentMockupPos.X
						end
						showSnapLine(self, "X", bestTargetX)
					end

					-- Find best Y Snap alignment
					local bestDiffY = threshold
					local bestTargetY = nil
					local snapTypeY = nil

					for _, targetY in ipairs(yTargets) do
						local diffT = math.abs(mockupTopLeft.Y - targetY)
						if diffT < bestDiffY then
							bestDiffY = diffT
							bestTargetY = targetY
							snapTypeY = "top"
						end
						local diffC = math.abs((mockupTopLeft.Y + elSize.Y / 2) - targetY)
						if diffC < bestDiffY then
							bestDiffY = diffC
							bestTargetY = targetY
							snapTypeY = "center"
						end
						local diffB = math.abs((mockupTopLeft.Y + elSize.Y) - targetY)
						if diffB < bestDiffY then
							bestDiffY = diffB
							bestTargetY = targetY
							snapTypeY = "bottom"
						end
					end

					if bestTargetY then
						snappedY = true
						if snapTypeY == "top" then
							visualY = bestTargetY - parentMockupPos.Y
						elseif snapTypeY == "center" then
							visualY = (bestTargetY - elSize.Y / 2) - parentMockupPos.Y
						elseif snapTypeY == "bottom" then
							visualY = (bestTargetY - elSize.Y) - parentMockupPos.Y
						end
						showSnapLine(self, "Y", bestTargetY)
					end
				end

				if not snappedX then hideSnapLine(self, "X") end
				if not snappedY then hideSnapLine(self, "Y") end

				newX = visualX + anchor[1] * elSize.X
				newY = visualY + anchor[2] * elSize.Y
				
				local unitMode = "Offset"
				local basePos = el.properties.Position or {0, 0, 0, 0}
				if basePos[1] > 0 or basePos[3] > 0 then unitMode = "Scale" end
				
				local finalVal = {0, 0, 0, 0}
				if unitMode == "Scale" then
					finalVal = {newX / parentSize.X, 0, newY / parentSize.Y, 0}
				else
					finalVal = {0, math.round(newX), 0, math.round(newY)}
				end
				
				self:updateAnimationKeyframe(el.name, "Position", finalVal)
				
			elseif self._isResizing and self._resizedElement and self._resizeHandleType then
				local mousePos = input.Position
				local delta = (mousePos - self._resizeStartMousePos) / scale
				
				local startW = self._resizeStartElementSize.X
				local startH = self._resizeStartElementSize.Y
				local startX = self._resizeStartElementPos.X
				local startY = self._resizeStartElementPos.Y
				
				local newW, newH = startW, startH
				local newX, newY = startX, startY
				
				local handle = self._resizeHandleType
				if handle == "BR" then
					newW = startW + delta.X
					newH = startH + delta.Y
				elseif handle == "TR" then
					newW = startW + delta.X
					newH = startH - delta.Y
					newY = startY + delta.Y
				elseif handle == "BL" then
					newW = startW - delta.X
					newH = startH + delta.Y
					newX = startX + delta.X
				elseif handle == "TL" then
					newW = startW - delta.X
					newH = startH - delta.Y
					newX = startX + delta.X
					newY = startY + delta.Y
				end
				
				if newW < 5 then
					if handle == "BL" or handle == "TL" then newX = startX + (startW - 5) end
					newW = 5
				end
				if newH < 5 then
					if handle == "TR" or handle == "TL" then newY = startY + (startH - 5) end
					newH = 5
				end
				
				local el = self._resizedElement
				local parentSize = getVirtualParentSize(self, el)
				
				local unitMode = "Offset"
				local baseSize = el.properties.Size or {0, 100, 0, 100}
				if baseSize[1] > 0 or baseSize[3] > 0 then unitMode = "Scale" end
				
				local finalSize = {0, 0, 0, 0}
				local finalPos = {0, 0, 0, 0}
				
				if unitMode == "Scale" then
					finalSize = {newW / parentSize.X, 0, newH / parentSize.Y, 0}
					finalPos = {newX / parentSize.X, 0, newY / parentSize.Y, 0}
				else
					finalSize = {0, math.round(newW), 0, math.round(newH)}
					finalPos = {0, math.round(newX), 0, math.round(newY)}
				end
				
				self:updateAnimationKeyframe(el.name, "Size", finalSize)
				self:updateAnimationKeyframe(el.name, "Position", finalPos)
			end
		end
	end)

	-- Keyboard shortcuts local fallback listener
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			self._ctrlHeld = true
		end
		self:handleKeyDown(input.KeyCode)
	end)

	UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
			self._ctrlHeld = false
		end
	end)

	-- Local frame keyboard capture (substitute for parent widget events)
	mainFrame.Active = true
	mainFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
				self._ctrlHeld = true
			end
			self:handleKeyDown(input.KeyCode)
		end
	end)

	mainFrame.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
				self._ctrlHeld = false
			end
		end
	end)

	keyboardCapture.Focused:Connect(function()
	end)

	keyboardCapture.FocusLost:Connect(function(enterPressed)
		task.defer(function()
			if not self._frame.Visible then return end
			local focused = UserInputService:GetFocusedTextBox()
			if not focused then
				keyboardCapture:CaptureFocus()
			end
		end)
	end)

	return self
end

function AnimationEditor:GetInstance()
	return self._frame
end

function AnimationEditor:handleKeyDown(keyCode, isCtrlHeld)
	if not self._frame.Visible then return end
	if not self._sData or self._sData.type ~= "UI" then return end
	
	local focusedTextBox = UserInputService:GetFocusedTextBox()
	if focusedTextBox and focusedTextBox ~= self._keyboardCapture then
		return
	end

	if isCtrlHeld ~= nil then
		self._ctrlHeld = isCtrlHeld
	end


	local ctrlHeld = self._ctrlHeld or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)

	if ctrlHeld and keyCode == Enum.KeyCode.C then
		if self._selectedKeyframe then
			self._copiedKeyframe = {
				value = cloneValue(self._selectedKeyframe.value),
				easingStyle = self._selectedKeyframe.easingStyle or "Quad",
				easingDirection = self._selectedKeyframe.easingDirection or "Out"
			}
		else
		end
	elseif ctrlHeld and keyCode == Enum.KeyCode.V then
		if self._copiedKeyframe and self._selectedTrack then
			local track = self._selectedTrack
			local exists = nil
			for _, kf in ipairs(track.keyframes) do
				if math.abs(kf.time - self._currentTime) < 0.01 then
					exists = kf
					break
				end
			end

			if exists then
				exists.value = cloneValue(self._copiedKeyframe.value)
				exists.easingStyle = self._copiedKeyframe.easingStyle
				exists.easingDirection = self._copiedKeyframe.easingDirection
				self._selectedKeyframe = exists
			else
				local newKf = {
					time = self._currentTime,
					value = cloneValue(self._copiedKeyframe.value),
					easingStyle = self._copiedKeyframe.easingStyle,
					easingDirection = self._copiedKeyframe.easingDirection
				}
				table.insert(track.keyframes, newKf)
				self._selectedKeyframe = newKf
			end
			self:refreshTimeline()
			self:refreshControls()
		else
		end
	elseif keyCode == Enum.KeyCode.K then
		if self._selectedTrack then
			local track = self._selectedTrack
			local exists = nil
			for _, kf in ipairs(track.keyframes) do
				if math.abs(kf.time - self._currentTime) < 0.01 then
					exists = kf
					break
				end
			end

			if not exists then
				local capVal = nil
				local el = nil
				local function findEl(elements)
					for _, e in ipairs(elements) do
						if e.name == track.elementName then el = e; break end
						if e.children then findEl(e.children) end
					end
				end
				findEl(self._uiElements)

				if el then
					capVal = getElementProperty(el, track.property)
				else
					capVal = 0
				end

				local kf = {
					time = self._currentTime,
					value = capVal,
					easingStyle = "Quad",
					easingDirection = "Out"
				}
				table.insert(track.keyframes, kf)
				self._selectedKeyframe = kf
				self:refreshTimeline()
				self:refreshControls()
			else
			end
		end
	elseif keyCode == Enum.KeyCode.Delete or keyCode == Enum.KeyCode.Backspace then
		if self._selectedTrack and self._selectedKeyframe then
			local track = self._selectedTrack
			local deleted = false
			for idx, kf in ipairs(track.keyframes) do
				if kf == self._selectedKeyframe then
					table.remove(track.keyframes, idx)
					deleted = true
					break
				end
			end
			if deleted then
				self._selectedKeyframe = nil
				self:refreshTimeline()
				self:refreshControls()
				self:refreshViewport()
			else
			end
		else
		end
	elseif keyCode == Enum.KeyCode.Space then
		if self._activeAnimation then
			if self._playing then
				self._playing = false
			else
				self._playing = true
				task.spawn(function()
					local lastTime = os.clock()
					while self._playing do
						RunService.Heartbeat:Wait()
						local now = os.clock()
						local dt = now - lastTime
						lastTime = now
						
						self._currentTime = self._currentTime + dt
						if self._currentTime >= self._activeAnimation.duration then
							self._currentTime = 0
						end
						self:updatePlayheadAndScrub()
					end
				end)
			end
		end
	end
end

function AnimationEditor:LoadScript(sData)
	self:SaveState()

	self._sData = sData
	self._uiElements = sData.uiElements or {}
	self._animations = sData.animations or {}
	self._selectedElement = nil
	self._selectedTrack = nil
	self._selectedKeyframe = nil
	self._currentTime = 0.0
	self._playing = false

	if #self._animations > 0 then
		self._activeAnimation = self._animations[1]
	else
		self._activeAnimation = nil
	end

	self:refreshAll()
end

function AnimationEditor:SaveState()
	if self._sData then
		self._sData.animations = self._animations
	end
end

function AnimationEditor:refreshAll()
	self:refreshHierarchy()
	self:refreshViewport()
	self:refreshTimeline()
	self:refreshControls()
end

-- Render the UI elements list hierarchy
function AnimationEditor:refreshHierarchy()
	for _, child in ipairs(self._hierarchyScroll:GetChildren()) do
		if child:IsA("GuiObject") then child:Destroy() end
	end

	local list = {}
	local function flatten(elements, depth)
		for _, el in ipairs(elements) do
			table.insert(list, {el = el, depth = depth})
			if el.children then
				flatten(el.children, depth + 1)
			end
		end
	end
	flatten(self._uiElements, 0)

	local rowIdx = 1
	for _, item in ipairs(list) do
		local isSel = self._selectedElement == item.el
		local indent = item.depth * 12

		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundTransparency = 1
		row.LayoutOrder = rowIdx
		row.Parent = self._hierarchyScroll

		local rowBg = Instance.new("Frame")
		rowBg.Size = UDim2.new(1, 0, 1, 0)
		rowBg.BackgroundColor3 = isSel and Color3.fromRGB(38, 70, 140) or ((rowIdx % 2 == 0) and Color3.fromRGB(22, 28, 42) or Color3.fromRGB(16, 21, 32))
		rowBg.BackgroundTransparency = isSel and 0.2 or 0.5
		rowBg.BorderSizePixel = 0
		rowBg.Parent = row
		makeCorner(rowBg, 4)

		local nameBtn = Instance.new("TextButton")
		nameBtn.Size = UDim2.new(1, -indent - 40, 1, 0)
		nameBtn.Position = UDim2.new(0, indent + 4, 0, 0)
		nameBtn.BackgroundTransparency = 1
		nameBtn.Text = " " .. (CLASS_ICONS[item.el.class] or "⬜") .. " " .. item.el.name
		nameBtn.TextColor3 = isSel and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 175, 205)
		nameBtn.TextSize = 10
		nameBtn.Font = isSel and Enum.Font.GothamBold or Enum.Font.GothamMedium
		nameBtn.TextXAlignment = Enum.TextXAlignment.Left
		nameBtn.Parent = row

		nameBtn.MouseButton1Click:Connect(function()
			self._keyboardCapture:CaptureFocus()
			self._selectedElement = item.el
			self:refreshHierarchy()
			self:refreshViewport()
			self:refreshControls()
		end)

		local animBtn = Instance.new("TextButton")
		animBtn.Size = UDim2.fromOffset(18, 18)
		animBtn.Position = UDim2.new(1, -22, 0.5, -9)
		animBtn.BackgroundColor3 = Color3.fromRGB(40, 55, 80)
		animBtn.Text = "+"
		animBtn.TextColor3 = Color3.fromRGB(100, 200, 255)
		animBtn.TextSize = 11
		animBtn.Font = Enum.Font.GothamBold
		animBtn.Parent = row
		makeCorner(animBtn, 4)

		animBtn.MouseButton1Click:Connect(function()
			ChoiceModal.prompt(self._frame, "Animate Property", ANIMATABLE_PROPERTIES, function(selectedProp)
				self:addTrack(item.el.name, selectedProp)
			end)
		end)

		rowIdx += 1
	end

	self._hierarchyScroll.CanvasSize = UDim2.new(0, 0, 0, rowIdx * 26)
end

function AnimationEditor:updateAnimationKeyframe(elementName, propertyName, value)
	if not self._activeAnimation then return end
	self._activeAnimation.tracks = self._activeAnimation.tracks or {}

	local track = nil
	for _, t in ipairs(self._activeAnimation.tracks) do
		if t.elementName == elementName and t.property == propertyName then
			track = t
			break
		end
	end
	if not track then
		track = {
			elementName = elementName,
			property = propertyName,
			keyframes = {}
		}
		table.insert(self._activeAnimation.tracks, track)
	end

	local kf = nil
	for _, k in ipairs(track.keyframes) do
		if math.abs(k.time - self._currentTime) < 0.01 then
			kf = k
			break
		end
	end
	if not kf then
		kf = {
			time = self._currentTime,
			easingStyle = "Quad",
			easingDirection = "Out"
		}
		table.insert(track.keyframes, kf)
	end

	kf.value = value
	self._selectedTrack = track
	self._selectedKeyframe = kf

	self:refreshTimeline()
	self:refreshControls()
	self:refreshViewport()
end

-- Render the viewport with animated values applied
function AnimationEditor:refreshViewport()
	self._viewportInstances = {}
	for _, child in self._viewportMockup:GetChildren() do
		if child:IsA("GuiObject") and child.Name ~= "ViewportLabel" and child.Name ~= "SnapLineX" and child.Name ~= "SnapLineY" then
			child:Destroy()
		end
	end

	-- Evaluate animation values at _currentTime
	local animatedProps = {}
	if self._activeAnimation then
		for _, track in ipairs(self._activeAnimation.tracks or {}) do
			local val = evaluateTrack(track, self._currentTime)
			if val ~= nil then
				if not animatedProps[track.elementName] then
					animatedProps[track.elementName] = {}
				end
				animatedProps[track.elementName][track.property] = val
			end
		end
	end

	local function buildLiveGui(elements, parentGui)
		for _, el in ipairs(elements) do
			local inst = Instance.new(el.class)
			inst.Name = el.name
			if inst:IsA("GuiObject") then
				inst.ZIndex = 2
			end
			self._viewportInstances[el.name] = inst

			-- Apply base design properties
			for p, val in pairs(el.properties or {}) do
				pcall(function()
					if p == "Position" or p == "Size" or p == "CanvasSize" or p == "CellSize" or p == "CellPadding" then
						inst[p] = UDim2.new(unpack(val))
					elseif p == "CornerRadius" or p == "Padding" or p == "PaddingTop" or p == "PaddingBottom" or p == "PaddingLeft" or p == "PaddingRight" then
						inst[p] = UDim.new(unpack(val))
					elseif p == "AnchorPoint" or p == "MaxSize" or p == "MinSize" or p == "Offset" then
						inst[p] = Vector2.new(unpack(val))
					elseif p == "BackgroundColor3" or p == "BorderColor3" or p == "TextColor3" or p == "ScrollBarImageColor3" or p == "Color" then
						inst[p] = Color3.fromRGB(val[1], val[2], val[3])
					elseif typeof(val) == "boolean" or typeof(val) == "number" or typeof(val) == "string" then
						local enumTypes = {
							Font = true, TextXAlignment = true, TextYAlignment = true,
							FillDirection = true, HorizontalAlignment = true, VerticalAlignment = true,
							SortOrder = true, AspectType = true, DominantAxis = true,
							ApplyStrokeMode = true, LineJoinMode = true, TableMajorAxis = true, StartCorner = true
						}
						local enumName = p
						if enumTypes[p] or enumTypes[enumName] then
							inst[p] = Enum[enumName][val]
						else
							inst[p] = val
						end
					end
				end)
			end

			-- Apply Animated values if present
			local anims = animatedProps[el.name]
			if anims then
				for p, val in pairs(anims) do
					pcall(function()
						if p == "Position" or p == "Size" then
							inst[p] = UDim2.new(unpack(val))
						elseif p == "BackgroundColor3" or p == "TextColor3" or p == "ImageColor3" then
							inst[p] = Color3.fromRGB(val[1], val[2], val[3])
						else
							inst[p] = val
						end
					end)
				end
			end

			inst.Parent = parentGui

			if inst:IsA("GuiObject") then
				local hitbox = Instance.new("TextButton")
				hitbox.Name = "Hitbox"
				hitbox.Size = UDim2.new(1, 0, 1, 0)
				hitbox.BackgroundTransparency = 1
				hitbox.Text = ""
				hitbox.ZIndex = 1
				hitbox.Parent = inst

				self:hookUpHitbox(el, hitbox, inst)
			end

			if el.children and #el.children > 0 then
				buildLiveGui(el.children, inst)
			end
		end
	end

	buildLiveGui(self._uiElements, self._viewportMockup)
	self:updateSelectionOutline()
end

function AnimationEditor:updateSelectionOutline()
	local function clearSelectionVisuals(parent)
		for _, child in parent:GetChildren() do
			if child.Name == "SelectionOutline" or child.Name == "ResizeHandle" then
				child:Destroy()
			else
				clearSelectionVisuals(child)
			end
		end
	end
	clearSelectionVisuals(self._viewportMockup)

	for _, inst in pairs(self._viewportInstances) do
		if inst:IsA("GuiObject") then
			inst.ZIndex = 2
		end
	end

	local el = self._selectedElement
	if not el then return end

	local inst = self._viewportInstances[el.name]
	if not inst then return end

	if inst:IsA("GuiObject") then
		inst.ZIndex = 10000
	end

	if inst:IsA("GuiObject") then
		local outline = Instance.new("UIStroke")
		outline.Name = "SelectionOutline"
		outline.Color = ACCENT_COLOR
		outline.Thickness = 2
		outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		outline.Parent = inst

		local handles = {
			TL = UDim2.new(0, -4, 0, -4),
			TR = UDim2.new(1, -4, 0, -4),
			BL = UDim2.new(0, -4, 1, -4),
			BR = UDim2.new(1, -4, 1, -4),
		}

		for name, pos in pairs(handles) do
			local handle = Instance.new("TextButton")
			handle.Name = "ResizeHandle"
			handle.Size = UDim2.fromOffset(8, 8)
			handle.Position = pos
			handle.BackgroundColor3 = ACCENT_COLOR
			handle.BorderSizePixel = 0
			handle.Text = ""
			handle.ZIndex = 1001
			handle.Active = true
			makeCorner(handle, 2)
			handle.Parent = inst

			handle.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					self._keyboardCapture:CaptureFocus()
					self._isResizing = true
					self._resizedElement = el
					self._resizedInstance = inst
					self._resizeHandleType = name
					self._resizeStartMousePos = input.Position
					
					local curSize = getAnimatedOrBaseProperty(self, el.name, "Size", el.properties.Size or {0, 100, 0, 100})
					local curPos = getAnimatedOrBaseProperty(self, el.name, "Position", el.properties.Position or {0, 0, 0, 0})
					
					local parentSize = getVirtualParentSize(self, el)
					local w = curSize[1] * parentSize.X + curSize[2]
					local h = curSize[3] * parentSize.Y + curSize[4]
					self._resizeStartElementSize = Vector2.new(w, h)
					
					local x = curPos[1] * parentSize.X + curPos[2]
					local y = curPos[3] * parentSize.Y + curPos[4]
					self._resizeStartElementPos = Vector2.new(x, y)

					local endConn
					endConn = input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							self._isResizing = false
							self._resizedElement = nil
							self._resizedInstance = nil
							self._resizeHandleType = nil
							self:refreshViewport()
							self:refreshControls()
							self:refreshTimeline()
							endConn:Disconnect()
						end
					end)
				end
			end)
		end
	end
end

function AnimationEditor:hookUpHitbox(el, hitbox, inst)
	hitbox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self._keyboardCapture:CaptureFocus()
			self._selectedElement = el
			self:refreshHierarchy()
			self:updateSelectionOutline()
			self:refreshControls()

			self._isDragging = true
			self._draggedElement = el
			self._draggedInstance = inst
			self._dragStartMousePos = input.Position
			
			local curPos = getAnimatedOrBaseProperty(self, el.name, "Position", el.properties.Position or {0, 0, 0, 0})
			local parentSize = getVirtualParentSize(self, el)
			local x = curPos[1] * parentSize.X + curPos[2]
			local y = curPos[3] * parentSize.Y + curPos[4]
			self._dragStartElementPos = Vector2.new(x, y)

			local endConn
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					self._isDragging = false
					self._draggedElement = nil
					self._draggedInstance = nil
					hideSnapLine(self, "X")
					hideSnapLine(self, "Y")
					self:refreshViewport()
					self:refreshControls()
					self:refreshTimeline()
					endConn:Disconnect()
				end
			end)
		end
	end)
end

-- Refresh the Timeline Panel at the bottom
function AnimationEditor:refreshTimeline()
	for _, child in ipairs(self._timelineScroll:GetChildren()) do
		if child:IsA("GuiObject") then child:Destroy() end
	end
	for _, child in ipairs(self._timelinePanel.Header:GetChildren()) do
		if child:IsA("TextLabel") then child:Destroy() end
	end

	local anim = self._activeAnimation
	if not anim then
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = "No active animation selected."
		label.TextColor3 = Color3.fromRGB(100, 120, 150)
		label.TextSize = 12
		label.Font = Enum.Font.GothamMedium
		label.Parent = self._timelineScroll
		self._playheadLine.Visible = false
		return
	end

	self._playheadLine.Visible = true

	local duration = anim.duration or 1.0
	local timelineWidth = 600 -- width for tracks in pixels
	self._timelineScroll.CanvasSize = UDim2.new(0, timelineWidth + 180, 0, 0)

	-- Time markers in the header
	local intervals = math.clamp(math.round(duration * 5), 5, 20)
	for i = 0, intervals do
		local tVal = (i / intervals) * duration
		local marker = Instance.new("TextLabel")
		marker.Size = UDim2.new(0, 30, 1, 0)
		marker.Position = UDim2.new(0, 180 + (tVal / duration) * timelineWidth - 15, 0, 0)
		marker.BackgroundTransparency = 1
		marker.Text = string.format("%.1fs", tVal)
		marker.TextColor3 = Color3.fromRGB(110, 130, 160)
		marker.TextSize = 9
		marker.Font = Enum.Font.GothamMedium
		marker.Parent = self._timelinePanel.Header
	end

	-- Timeline click/scrub handler in the header
	local headerButton = Instance.new("TextButton")
	headerButton.Size = UDim2.new(0, timelineWidth, 1, 0)
	headerButton.Position = UDim2.new(0, 180, 0, 0)
	headerButton.BackgroundTransparency = 1
	headerButton.Text = ""
	headerButton.ZIndex = 10
	headerButton.Parent = self._timelinePanel.Header

	local function processScrub(inputX)
		local localX = inputX - headerButton.AbsolutePosition.X
		local alpha = math.clamp(localX / timelineWidth, 0, 1)
		self._currentTime = alpha * duration
		self:updatePlayheadAndScrub()
		self:refreshControls()
	end

	headerButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self._keyboardCapture:CaptureFocus()
			processScrub(input.Position.X)
			local conn
			conn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					conn:Disconnect()
				end
			end)
			local dragConn
			dragConn = self._frame.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
					processScrub(moveInput.Position.X)
				end
			end)
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragConn:Disconnect()
				end
			end)
		end
	end)

	-- Draw active tracks
	local tracks = anim.tracks or {}
	local rowIdx = 1
	for idx, track in ipairs(tracks) do
		local isTrackSelected = self._selectedTrack == track
		local trackColor = TRACK_COLORS[track.property] or Color3.fromRGB(150, 170, 200)

		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 24)
		row.BackgroundTransparency = 1
		row.LayoutOrder = rowIdx
		row.Parent = self._timelineScroll

		local rowBg = Instance.new("Frame")
		rowBg.Size = UDim2.new(1, 0, 1, 0)
		rowBg.BackgroundColor3 = isTrackSelected and Color3.fromRGB(30, 45, 80) or ((rowIdx % 2 == 0) and Color3.fromRGB(22, 28, 42) or Color3.fromRGB(16, 21, 32))
		rowBg.BackgroundTransparency = 0.5
		rowBg.BorderSizePixel = 0
		rowBg.Parent = row
		makeCorner(rowBg, 4)

		-- Delete track button
		local delTrack = Instance.new("TextButton")
		delTrack.Size = UDim2.fromOffset(14, 14)
		delTrack.Position = UDim2.new(0, 4, 0.5, -7)
		delTrack.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
		delTrack.Text = "x"
		delTrack.TextColor3 = Color3.fromRGB(255, 120, 120)
		delTrack.TextSize = 9
		delTrack.Font = Enum.Font.GothamBold
		delTrack.Parent = row
		makeCorner(delTrack, 3)

		-- Color indicator dot
		local dot = Instance.new("Frame")
		dot.Size = UDim2.fromOffset(6, 6)
		dot.Position = UDim2.new(0, 24, 0.5, -3)
		dot.BackgroundColor3 = trackColor
		dot.BorderSizePixel = 0
		dot.Parent = row
		makeCorner(dot, 3)

		-- Track description
		local trackBtn = Instance.new("TextButton")
		trackBtn.Size = UDim2.new(0, 144, 1, 0)
		trackBtn.Position = UDim2.new(0, 34, 0, 0)
		trackBtn.BackgroundTransparency = 1
		trackBtn.Text = " " .. track.elementName .. " • " .. track.property
		trackBtn.TextColor3 = isTrackSelected and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 175, 205)
		trackBtn.TextSize = 10
		trackBtn.Font = isTrackSelected and Enum.Font.GothamBold or Enum.Font.GothamMedium
		trackBtn.TextXAlignment = Enum.TextXAlignment.Left
		trackBtn.Parent = row

		trackBtn.MouseButton1Click:Connect(function()
			self._keyboardCapture:CaptureFocus()
			self._selectedTrack = track
			self._selectedKeyframe = nil
			self:refreshTimeline()
			self:refreshControls()
		end)

		-- Track timeline lane
		local lane = Instance.new("Frame")
		lane.Name = "Lane"
		lane.Size = UDim2.new(0, timelineWidth, 1, 0)
		lane.Position = UDim2.new(0, 180, 0, 0)
		lane.BackgroundTransparency = 1
		lane.Parent = row

		-- Gridlines inside lanes
		for i = 1, intervals - 1 do
			local linePos = (i / intervals)
			local line = Instance.new("Frame")
			line.Size = UDim2.new(0, 1, 1, 0)
			line.Position = UDim2.new(linePos, 0, 0, 0)
			line.BackgroundColor3 = Color3.fromRGB(30, 40, 60)
			line.BackgroundTransparency = 0.65
			line.BorderSizePixel = 0
			line.Parent = lane
		end

		lane.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				self._keyboardCapture:CaptureFocus()
				self._selectedTrack = track
				self:refreshTimeline()
				self:refreshControls()
			end
		end)

		-- Render Keyframe diamonds
		for _, kf in ipairs(track.keyframes or {}) do
			local isKfSelected = self._selectedKeyframe == kf
			local diamond = Instance.new("TextButton")
			diamond.Size = isKfSelected and UDim2.fromOffset(10, 10) or UDim2.fromOffset(8, 8)
			diamond.Rotation = 45
			diamond.Position = UDim2.new(kf.time / duration, isKfSelected and -5 or -4, 0.5, isKfSelected and -5 or -4)
			diamond.BackgroundColor3 = isKfSelected and SELECTED_KEYFRAME_COLOR or trackColor
			diamond.BorderSizePixel = 0
			diamond.Text = ""
			diamond.AutoButtonColor = false
			diamond.Parent = lane

			if isKfSelected then
				local kfStroke = Instance.new("UIStroke")
				kfStroke.Color = Color3.new(255, 255, 255)
				kfStroke.Thickness = 1
				kfStroke.Parent = diamond
			end

			diamond.MouseButton1Click:Connect(function()
				self._keyboardCapture:CaptureFocus()
				self._selectedTrack = track
				self._selectedKeyframe = kf
				self:refreshTimeline()
				self:refreshControls()
			end)

			-- Draggable keyframe functionality
			diamond.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					self._keyboardCapture:CaptureFocus()
					local dragConn
					dragConn = self._frame.InputChanged:Connect(function(moveInput)
						if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
							local relX = moveInput.Position.X - lane.AbsolutePosition.X
							local newT = math.clamp(relX / timelineWidth, 0, 1) * duration
							newT = math.round(newT * 20) / 20 -- snap to 0.05 seconds
							kf.time = newT
							diamond.Position = UDim2.new(kf.time / duration, -4, 0.5, -4)
							self:updatePlayheadAndScrub()
							self:refreshControls()
						end
					end)
					input.Changed:Connect(function()
						if input.UserInputState == Enum.UserInputState.End then
							dragConn:Disconnect()
							self:refreshTimeline()
						end
					end)
				end
			end)
		end

		rowIdx += 1
	end

	self._timelineScroll.CanvasSize = UDim2.new(0, timelineWidth + 190, 0, rowIdx * 26)
	self:updatePlayheadAndScrub()
end

function AnimationEditor:updatePlayheadAndScrub()
	if not self._activeAnimation then return end
	local duration = self._activeAnimation.duration or 1.0
	local timelineWidth = 600

	local scrubberLeftOffset = 180 + 4
	local playheadX = scrubberLeftOffset + (self._currentTime / duration) * timelineWidth
	self._playheadLine.Position = UDim2.new(0, playheadX, 0, 0)

	self:refreshViewport()
end

-- Setup Right Panel properties and animation lists
function AnimationEditor:buildControls()
	local rScroll = self._rightScroll

	-- Section 1: Animation Management
	local animHeader = Instance.new("TextLabel")
	animHeader.Size = UDim2.new(1, 0, 0, 20)
	animHeader.BackgroundTransparency = 1
	animHeader.Text = "ANIMATIONS"
	animHeader.TextColor3 = ACCENT_COLOR
	animHeader.TextSize = 10
	animHeader.Font = Enum.Font.GothamBold
	animHeader.TextXAlignment = Enum.TextXAlignment.Left
	animHeader.LayoutOrder = 1
	animHeader.Parent = rScroll

	-- Animations Sidebar List Panel (single click navigation!)
	local animListContainer = Instance.new("Frame")
	animListContainer.Size = UDim2.new(1, 0, 0, 100)
	animListContainer.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	animListContainer.BorderSizePixel = 0
	animListContainer.LayoutOrder = 2
	animListContainer.Parent = rScroll
	makeCorner(animListContainer, 4)
	makeBorder(animListContainer)
	self._animListContainer = animListContainer
	
	local animListScroll = Instance.new("ScrollingFrame")
	animListScroll.Size = UDim2.new(1, -8, 1, -8)
	animListScroll.Position = UDim2.new(0, 4, 0, 4)
	animListScroll.BackgroundTransparency = 1
	animListScroll.BorderSizePixel = 0
	animListScroll.ScrollBarThickness = 4
	animListScroll.Parent = animListContainer
	self._animListScroll = animListScroll
	
	local animListLayout = Instance.new("UIListLayout")
	animListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	animListLayout.Padding = UDim.new(0, 4)
	animListLayout.Parent = animListScroll

	-- Animation Action Buttons
	local actionsFrame = Instance.new("Frame")
	actionsFrame.Size = UDim2.new(1, 0, 0, 28)
	actionsFrame.BackgroundTransparency = 1
	actionsFrame.LayoutOrder = 3
	actionsFrame.Parent = rScroll

	local grid = Instance.new("UIGridLayout")
	grid.CellSize = UDim2.new(0.33, -4, 1, 0)
	grid.CellPadding = UDim2.fromOffset(6, 0)
	grid.Parent = actionsFrame

	local addAnim = Instance.new("TextButton")
	addAnim.BackgroundColor3 = Color3.fromRGB(30, 80, 40)
	addAnim.Text = "New"
	addAnim.TextColor3 = Color3.fromRGB(200, 255, 200)
	addAnim.TextSize = 10
	addAnim.Font = Enum.Font.GothamBold
	addAnim.Parent = actionsFrame
	makeCorner(addAnim, 4)

	addAnim.MouseButton1Click:Connect(function()
		Modal.prompt(self._frame, "New Animation", "Enter animation name...", function(name)
			if name and name ~= "" then
				local cleanName = name:gsub("[^%w_]", "")
				if cleanName == "" then cleanName = "Anim" end
				
				local anim = {
					name = cleanName,
					duration = 1.0,
					tracks = {}
				}
				table.insert(self._animations, anim)
				self._activeAnimation = anim
				self._selectedTrack = nil
				self._selectedKeyframe = nil
				self:refreshAll()
			end
		end)
	end)

	local renameAnim = Instance.new("TextButton")
	renameAnim.BackgroundColor3 = Color3.fromRGB(40, 55, 80)
	renameAnim.Text = "Rename"
	renameAnim.TextColor3 = Color3.fromRGB(200, 220, 255)
	renameAnim.TextSize = 10
	renameAnim.Font = Enum.Font.GothamBold
	renameAnim.Parent = actionsFrame
	makeCorner(renameAnim, 4)

	renameAnim.MouseButton1Click:Connect(function()
		if not self._activeAnimation then return end
		Modal.prompt(self._frame, "Rename Animation", "Enter new name...", function(name)
			if name and name ~= "" then
				local cleanName = name:gsub("[^%w_]", "")
				if cleanName == "" then cleanName = "Anim" end
				self._activeAnimation.name = cleanName
				self:refreshAll()
			end
		end)
	end)

	local deleteAnim = Instance.new("TextButton")
	deleteAnim.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
	deleteAnim.Text = "Delete"
	deleteAnim.TextColor3 = Color3.fromRGB(255, 200, 200)
	deleteAnim.TextSize = 10
	deleteAnim.Font = Enum.Font.GothamBold
	deleteAnim.Parent = actionsFrame
	makeCorner(deleteAnim, 4)

	deleteAnim.MouseButton1Click:Connect(function()
		if not self._activeAnimation then return end
		for idx, a in ipairs(self._animations) do
			if a == self._activeAnimation then
				table.remove(self._animations, idx)
				break
			end
		end
		self._activeAnimation = #self._animations > 0 and self._animations[1] or nil
		self._selectedTrack = nil
		self._selectedKeyframe = nil
		self:refreshAll()
	end)

	-- Section 2: Playback Settings
	local playbackHeader = Instance.new("TextLabel")
	playbackHeader.Size = UDim2.new(1, 0, 0, 20)
	playbackHeader.BackgroundTransparency = 1
	playbackHeader.Text = "PLAYBACK & CONFIG"
	playbackHeader.TextColor3 = ACCENT_COLOR
	playbackHeader.TextSize = 10
	playbackHeader.Font = Enum.Font.GothamBold
	playbackHeader.TextXAlignment = Enum.TextXAlignment.Left
	playbackHeader.LayoutOrder = 4
	playbackHeader.Parent = rScroll

	-- Duration field
	local durationRow = Instance.new("Frame")
	durationRow.Size = UDim2.new(1, 0, 0, 28)
	durationRow.BackgroundTransparency = 1
	durationRow.LayoutOrder = 5
	durationRow.Parent = rScroll

	local durLabel = Instance.new("TextLabel")
	durLabel.Size = UDim2.new(0.5, 0, 1, 0)
	durLabel.BackgroundTransparency = 1
	durLabel.Text = "Duration (s):"
	durLabel.TextColor3 = TEXT_COLOR
	durLabel.TextSize = 10
	durLabel.Font = Enum.Font.GothamMedium
	durLabel.TextXAlignment = Enum.TextXAlignment.Left
	durLabel.Parent = durationRow

	local durInput = Instance.new("TextBox")
	durInput.Size = UDim2.new(0.5, 0, 1, 0)
	durInput.Position = UDim2.new(0.5, 0, 0, 0)
	durInput.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
	durInput.Text = "1.0"
	durInput.TextColor3 = Color3.fromRGB(255, 255, 255)
	durInput.TextSize = 11
	durInput.Font = Enum.Font.GothamMedium
	durInput.ClearTextOnFocus = false
	durInput.Parent = durationRow
	makeCorner(durInput, 4)
	makeBorder(durInput)
	self._durInput = durInput

	durInput.FocusLost:Connect(function()
		local val = tonumber(durInput.Text)
		if val and val > 0 and self._activeAnimation then
			self._activeAnimation.duration = val
			self:refreshTimeline()
		elseif self._activeAnimation then
			durInput.Text = tostring(self._activeAnimation.duration)
		end
	end)

	-- Play/Pause controls
	local playbackFrame = Instance.new("Frame")
	playbackFrame.Size = UDim2.new(1, 0, 0, 30)
	playbackFrame.BackgroundTransparency = 1
	playbackFrame.LayoutOrder = 6
	playbackFrame.Parent = rScroll

	local playGrid = Instance.new("UIGridLayout")
	playGrid.CellSize = UDim2.new(0.33, -4, 1, 0)
	playGrid.CellPadding = UDim2.fromOffset(6, 0)
	playGrid.Parent = playbackFrame

	local playBtn = Instance.new("TextButton")
	playBtn.BackgroundColor3 = Color3.fromRGB(45, 120, 80)
	playBtn.Text = "▶ Play"
	playBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	playBtn.TextSize = 10
	playBtn.Font = Enum.Font.GothamBold
	playBtn.Parent = playbackFrame
	makeCorner(playBtn, 4)

	playBtn.MouseButton1Click:Connect(function()
		if not self._activeAnimation then return end
		if self._playing then return end
		self._playing = true
		
		task.spawn(function()
			local lastTime = os.clock()
			while self._playing do
				RunService.Heartbeat:Wait()
				local now = os.clock()
				local dt = now - lastTime
				lastTime = now
				
				self._currentTime = self._currentTime + dt
				if self._currentTime >= self._activeAnimation.duration then
					self._currentTime = 0
				end
				self:updatePlayheadAndScrub()
			end
		end)
	end)

	local pauseBtn = Instance.new("TextButton")
	pauseBtn.BackgroundColor3 = Color3.fromRGB(90, 80, 30)
	pauseBtn.Text = "⏸ Pause"
	pauseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	pauseBtn.TextSize = 10
	pauseBtn.Font = Enum.Font.GothamBold
	pauseBtn.Parent = playbackFrame
	makeCorner(pauseBtn, 4)

	pauseBtn.MouseButton1Click:Connect(function()
		self._playing = false
	end)

	local stopBtn = Instance.new("TextButton")
	stopBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
	stopBtn.Text = "⏹ Stop"
	stopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	stopBtn.TextSize = 10
	stopBtn.Font = Enum.Font.GothamBold
	stopBtn.Parent = playbackFrame
	makeCorner(stopBtn, 4)

	stopBtn.MouseButton1Click:Connect(function()
		self._playing = false
		self._currentTime = 0.0
		self:updatePlayheadAndScrub()
	end)

	-- Section 3: Keyframe & Selection Panel
	local kfHeader = Instance.new("TextLabel")
	kfHeader.Size = UDim2.new(1, 0, 0, 20)
	kfHeader.BackgroundTransparency = 1
	kfHeader.Text = "KEYFRAME CONFIG"
	kfHeader.TextColor3 = ACCENT_COLOR
	kfHeader.TextSize = 10
	kfHeader.Font = Enum.Font.GothamBold
	kfHeader.TextXAlignment = Enum.TextXAlignment.Left
	kfHeader.LayoutOrder = 7
	kfHeader.Parent = rScroll

	-- Keyframe Action Buttons (arranged in a 2x2 grid)
	local kfActionsRow = Instance.new("Frame")
	kfActionsRow.Size = UDim2.new(1, 0, 0, 60)
	kfActionsRow.BackgroundTransparency = 1
	kfActionsRow.LayoutOrder = 8
	kfActionsRow.Parent = rScroll

	local kfGrid = Instance.new("UIGridLayout")
	kfGrid.CellSize = UDim2.new(0.5, -4, 0, 26)
	kfGrid.CellPadding = UDim2.fromOffset(8, 4)
	kfGrid.Parent = kfActionsRow

	local addKf = Instance.new("TextButton")
	addKf.BackgroundColor3 = Color3.fromRGB(30, 80, 100)
	addKf.Text = "Add Keyframe"
	addKf.TextColor3 = Color3.fromRGB(220, 245, 255)
	addKf.TextSize = 10
	addKf.Font = Enum.Font.GothamBold
	addKf.Parent = kfActionsRow
	makeCorner(addKf, 4)

	addKf.MouseButton1Click:Connect(function()
		if not self._selectedTrack then return end
		local track = self._selectedTrack
		local exists = nil
		for _, kf in ipairs(track.keyframes) do
			if math.abs(kf.time - self._currentTime) < 0.01 then
				exists = kf
				break
			end
		end

		if not exists then
			local capVal = nil
			local el = nil
			local function findEl(elements)
				for _, e in ipairs(elements) do
					if e.name == track.elementName then el = e; break end
					if e.children then findEl(e.children) end
				end
			end
			findEl(self._uiElements)

			if el then
				capVal = getElementProperty(el, track.property)
			else
				capVal = 0
			end

			local kf = {
				time = self._currentTime,
				value = capVal,
				easingStyle = "Quad",
				easingDirection = "Out"
			}
			table.insert(track.keyframes, kf)
			self._selectedKeyframe = kf
			self:refreshTimeline()
			self:refreshControls()
		end
	end)

	local delKf = Instance.new("TextButton")
	delKf.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
	delKf.Text = "Delete Keyframe"
	delKf.TextColor3 = Color3.fromRGB(255, 200, 200)
	delKf.TextSize = 10
	delKf.Font = Enum.Font.GothamBold
	delKf.Parent = kfActionsRow
	makeCorner(delKf, 4)

	delKf.MouseButton1Click:Connect(function()
		if not self._selectedTrack or not self._selectedKeyframe then return end
		local track = self._selectedTrack
		for idx, kf in ipairs(track.keyframes) do
			if kf == self._selectedKeyframe then
				table.remove(track.keyframes, idx)
				break
			end
		end
		self._selectedKeyframe = nil
		self:refreshTimeline()
		self:refreshControls()
	end)

	local copyKf = Instance.new("TextButton")
	copyKf.BackgroundColor3 = Color3.fromRGB(40, 50, 75)
	copyKf.Text = "Copy Keyframe"
	copyKf.TextColor3 = Color3.fromRGB(200, 220, 255)
	copyKf.TextSize = 10
	copyKf.Font = Enum.Font.GothamBold
	copyKf.Parent = kfActionsRow
	makeCorner(copyKf, 4)

	copyKf.MouseButton1Click:Connect(function()
		if self._selectedKeyframe then
			self._copiedKeyframe = {
				value = cloneValue(self._selectedKeyframe.value),
				easingStyle = self._selectedKeyframe.easingStyle or "Quad",
				easingDirection = self._selectedKeyframe.easingDirection or "Out"
			}
		end
	end)

	local pasteKf = Instance.new("TextButton")
	pasteKf.BackgroundColor3 = Color3.fromRGB(45, 80, 60)
	pasteKf.Text = "Paste Keyframe"
	pasteKf.TextColor3 = Color3.fromRGB(200, 255, 220)
	pasteKf.TextSize = 10
	pasteKf.Font = Enum.Font.GothamBold
	pasteKf.Parent = kfActionsRow
	makeCorner(pasteKf, 4)

	pasteKf.MouseButton1Click:Connect(function()
		if self._copiedKeyframe and self._selectedTrack then
			local track = self._selectedTrack
			local exists = nil
			for _, kf in ipairs(track.keyframes) do
				if math.abs(kf.time - self._currentTime) < 0.01 then
					exists = kf
					break
				end
			end

			if exists then
				exists.value = cloneValue(self._copiedKeyframe.value)
				exists.easingStyle = self._copiedKeyframe.easingStyle
				exists.easingDirection = self._copiedKeyframe.easingDirection
				self._selectedKeyframe = exists
			else
				local newKf = {
					time = self._currentTime,
					value = cloneValue(self._copiedKeyframe.value),
					easingStyle = self._copiedKeyframe.easingStyle,
					easingDirection = self._copiedKeyframe.easingDirection
				}
				table.insert(track.keyframes, newKf)
				self._selectedKeyframe = newKf
			end
			self:refreshTimeline()
			self:refreshControls()
		end
	end)

	local kfDetailsFrame = Instance.new("Frame")
	kfDetailsFrame.Size = UDim2.new(1, 0, 0, 180)
	kfDetailsFrame.BackgroundTransparency = 1
	kfDetailsFrame.LayoutOrder = 9
	kfDetailsFrame.Parent = rScroll
	self._kfDetailsFrame = kfDetailsFrame

	local kfLayout = Instance.new("UIListLayout")
	kfLayout.SortOrder = Enum.SortOrder.LayoutOrder
	kfLayout.Padding = UDim.new(0, 6)
	kfLayout.Parent = kfDetailsFrame
end

function AnimationEditor:refreshControls()
	-- Refresh Active Animation Input Display
	local anim = self._activeAnimation
	if anim then
		self._durInput.Text = string.format("%.1f", anim.duration)
		self._animSelectBtn.Text = "🎬 " .. anim.name
	else
		self._durInput.Text = "1.0"
		self._animSelectBtn.Text = "🎬 Select Anim..."
	end

	-- Refresh Animation Sidebar items
	for _, child in ipairs(self._animListScroll:GetChildren()) do
		if child:IsA("GuiObject") then child:Destroy() end
	end
	
	local animIdx = 1
	for _, a in ipairs(self._animations) do
		local isAct = (a == self._activeAnimation)
		
		local item = Instance.new("TextButton")
		item.Size = UDim2.new(1, 0, 0, 22)
		item.BackgroundColor3 = isAct and Color3.fromRGB(38, 70, 120) or Color3.fromRGB(24, 30, 48)
		item.BorderSizePixel = 0
		item.Text = "  🎥  " .. a.name
		item.TextColor3 = isAct and Color3.new(1, 1, 1) or TEXT_COLOR
		item.TextSize = 10
		item.Font = isAct and Enum.Font.GothamBold or Enum.Font.GothamMedium
		item.TextXAlignment = Enum.TextXAlignment.Left
		item.LayoutOrder = animIdx
		item.Parent = self._animListScroll
		makeCorner(item, 4)
		
		item.MouseButton1Click:Connect(function()
			self._activeAnimation = a
			self._selectedTrack = nil
			self._selectedKeyframe = nil
			self._currentTime = 0.0
			self:refreshAll()
		end)
		
		animIdx += 1
	end
	self._animListScroll.CanvasSize = UDim2.new(0, 0, 0, animIdx * 26)

	-- Refresh Keyframe configuration options
	for _, child in ipairs(self._kfDetailsFrame:GetChildren()) do
		if child:IsA("GuiObject") then child:Destroy() end
	end

	local kf = self._selectedKeyframe
	local track = self._selectedTrack
	if not kf or not track then
		local placeholder = Instance.new("TextLabel")
		placeholder.Size = UDim2.new(1, 0, 0, 40)
		placeholder.BackgroundTransparency = 1
		placeholder.Text = "Select a keyframe on the timeline to edit values."
		placeholder.TextColor3 = Color3.fromRGB(100, 120, 150)
		placeholder.TextSize = 10
		placeholder.Font = Enum.Font.Gotham
		placeholder.TextWrapped = true
		placeholder.Parent = self._kfDetailsFrame
		return
	end

	local function createField(labelStr, controlWidth, renderFunc)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 26)
		row.BackgroundTransparency = 1
		row.Parent = self._kfDetailsFrame

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(0.4, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = labelStr
		lbl.TextColor3 = TEXT_COLOR
		lbl.TextSize = 10
		lbl.Font = Enum.Font.GothamMedium
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = row

		local ctrl = Instance.new("Frame")
		ctrl.Size = UDim2.new(0.6, 0, 1, 0)
		ctrl.Position = UDim2.new(0.4, 0, 0, 0)
		ctrl.BackgroundTransparency = 1
		ctrl.Parent = row

		renderFunc(ctrl)
	end

	-- Edit time
	createField("Time (s):", 0.6, function(parent)
		local input = Instance.new("TextBox")
		input.Size = UDim2.new(1, 0, 1, 0)
		input.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
		input.Text = string.format("%.2f", kf.time)
		input.TextColor3 = Color3.fromRGB(255, 255, 255)
		input.TextSize = 10
		input.Font = Enum.Font.GothamMedium
		input.ClearTextOnFocus = false
		input.Parent = parent
		makeCorner(input, 4)
		makeBorder(input)

		input.FocusLost:Connect(function()
			local num = tonumber(input.Text)
			if num and num >= 0 and self._activeAnimation then
				kf.time = math.clamp(num, 0, self._activeAnimation.duration)
				self:refreshTimeline()
			else
				input.Text = string.format("%.2f", kf.time)
			end
		end)
	end)

	-- Edit Value (based on track property)
	local pName = track.property
	if pName == "BackgroundTransparency" or pName == "TextTransparency" or pName == "ImageTransparency" or pName == "Rotation" then
		-- Single number
		createField("Value:", 0.6, function(parent)
			local input = Instance.new("TextBox")
			input.Size = UDim2.new(1, 0, 1, 0)
			input.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
			input.Text = tostring(kf.value)
			input.TextColor3 = Color3.fromRGB(255, 255, 255)
			input.TextSize = 10
			input.Font = Enum.Font.GothamMedium
			input.ClearTextOnFocus = false
			input.Parent = parent
			makeCorner(input, 4)
			makeBorder(input)

			input.FocusLost:Connect(function()
				local val = tonumber(input.Text)
				if val then
					if pName:find("Transparency") then
						kf.value = math.clamp(val, 0, 1)
					else
						kf.value = val
					end
					self:updatePlayheadAndScrub()
				else
					input.Text = tostring(kf.value)
				end
			end)
		end)
	elseif pName == "Position" or pName == "Size" then
		-- UDim2: scaleX, offsetX, scaleY, offsetY
		createField("Scale X,Y:", 0.6, function(parent)
			local input = Instance.new("TextBox")
			input.Size = UDim2.new(1, 0, 1, 0)
			input.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
			input.Text = string.format("%.2f, %.2f", kf.value[1], kf.value[3])
			input.TextColor3 = Color3.fromRGB(255, 255, 255)
			input.TextSize = 9
			input.Font = Enum.Font.GothamMedium
			input.ClearTextOnFocus = false
			input.Parent = parent
			makeCorner(input, 4)
			makeBorder(input)

			input.FocusLost:Connect(function()
				local parts = string.split(input.Text, ",")
				local sx = tonumber(parts[1])
				local sy = tonumber(parts[2])
				if sx and sy then
					kf.value[1] = sx
					kf.value[3] = sy
					self:updatePlayheadAndScrub()
				else
					input.Text = string.format("%.2f, %.2f", kf.value[1], kf.value[3])
				end
			end)
		end)
		createField("Offset X,Y:", 0.6, function(parent)
			local input = Instance.new("TextBox")
			input.Size = UDim2.new(1, 0, 1, 0)
			input.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
			input.Text = string.format("%d, %d", kf.value[2], kf.value[4])
			input.TextColor3 = Color3.fromRGB(255, 255, 255)
			input.TextSize = 9
			input.Font = Enum.Font.GothamMedium
			input.ClearTextOnFocus = false
			input.Parent = parent
			makeCorner(input, 4)
			makeBorder(input)

			input.FocusLost:Connect(function()
				local parts = string.split(input.Text, ",")
				local ox = tonumber(parts[1])
				local oy = tonumber(parts[2])
				if ox and oy then
					kf.value[2] = math.round(ox)
					kf.value[4] = math.round(oy)
					self:updatePlayheadAndScrub()
				else
					input.Text = string.format("%d, %d", kf.value[2], kf.value[4])
				end
			end)
		end)
	elseif pName:find("Color3") then
		createField("RGB:", 0.6, function(parent)
			local input = Instance.new("TextBox")
			input.Size = UDim2.new(1, 0, 1, 0)
			input.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
			input.Text = string.format("%d,%d,%d", kf.value[1], kf.value[2], kf.value[3])
			input.TextColor3 = Color3.fromRGB(255, 255, 255)
			input.TextSize = 10
			input.Font = Enum.Font.GothamMedium
			input.ClearTextOnFocus = false
			input.Parent = parent
			makeCorner(input, 4)
			makeBorder(input)

			input.FocusLost:Connect(function()
				local parts = string.split(input.Text, ",")
				local r = tonumber(parts[1])
				local g = tonumber(parts[2])
				local b = tonumber(parts[3])
				if r and g and b then
					kf.value[1] = math.clamp(math.round(r), 0, 255)
					kf.value[2] = math.clamp(math.round(g), 0, 255)
					kf.value[3] = math.clamp(math.round(b), 0, 255)
					self:updatePlayheadAndScrub()
				else
					input.Text = string.format("%d,%d,%d", kf.value[1], kf.value[2], kf.value[3])
				end
			end)
		end)
	end

	-- Edit EasingStyle
	createField("Easing Style:", 0.6, function(parent)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
		btn.Text = kf.easingStyle or "Linear"
		btn.TextColor3 = TEXT_COLOR
		btn.TextSize = 10
		btn.Font = Enum.Font.GothamMedium
		btn.Parent = parent
		makeCorner(btn, 4)
		makeBorder(btn)

		local styles = {"Linear", "Quad", "Cubic", "Quart", "Quint", "Sine", "Back", "Bounce", "Elastic", "Exponential", "Circular"}
		btn.MouseButton1Click:Connect(function()
			ChoiceModal.prompt(self._frame, "Easing Style", styles, function(choice)
				kf.easingStyle = choice
				btn.Text = choice
				self:updatePlayheadAndScrub()
			end)
		end)
	end)

	-- Edit EasingDirection
	createField("Easing Dir:", 0.6, function(parent)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 1, 0)
		btn.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
		btn.Text = kf.easingDirection or "Out"
		btn.TextColor3 = TEXT_COLOR
		btn.TextSize = 10
		btn.Font = Enum.Font.GothamMedium
		btn.Parent = parent
		makeCorner(btn, 4)
		makeBorder(btn)

		local dirs = {"In", "Out", "InOut"}
		btn.MouseButton1Click:Connect(function()
			ChoiceModal.prompt(self._frame, "Easing Direction", dirs, function(choice)
				kf.easingDirection = choice
				btn.Text = choice
				self:updatePlayheadAndScrub()
			end)
		end)
	end)
end

return AnimationEditor
