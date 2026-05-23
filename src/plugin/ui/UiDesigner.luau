local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local ChoiceModal = require(script.Parent.ChoiceModal)

local UiDesigner = {}
UiDesigner.__index = UiDesigner

local PANEL_BG = Color3.fromRGB(16, 21, 34)
local BORDER_COLOR = Color3.fromRGB(38, 50, 72)
local TEXT_COLOR = Color3.fromRGB(170, 195, 230)
local VIEWPORT_BG = Color3.fromRGB(10, 12, 20)

local PREMIUM_SWATCHES = {
	Color3.fromRGB(230, 75, 75),   -- Red
	Color3.fromRGB(240, 110, 80),  -- Coral
	Color3.fromRGB(245, 150, 60),  -- Orange
	Color3.fromRGB(245, 210, 60),  -- Yellow
	Color3.fromRGB(150, 220, 75),  -- Lime
	Color3.fromRGB(75, 190, 110),  -- Green
	Color3.fromRGB(60, 190, 175),  -- Teal
	Color3.fromRGB(60, 175, 230),  -- Cyan
	Color3.fromRGB(80, 140, 240),  -- Light Blue
	Color3.fromRGB(45, 100, 220),  -- Blue
	Color3.fromRGB(60, 75, 210),   -- Royal Blue
	Color3.fromRGB(130, 80, 230),  -- Purple
	Color3.fromRGB(200, 70, 200),  -- Magenta
	Color3.fromRGB(240, 100, 160), -- Pink
	Color3.fromRGB(255, 255, 255), -- White
	Color3.fromRGB(180, 185, 195), -- Light Gray
	Color3.fromRGB(100, 105, 115), -- Gray
	Color3.fromRGB(50, 55, 65),    -- Dark Gray
	Color3.fromRGB(30, 35, 45),     -- Charcoal
	Color3.fromRGB(0, 0, 0)        -- Black
}

local FONTS = {
	"SourceSans", "SourceSansBold", "SourceSansSemibold", "SourceSansLight",
	"Gotham", "GothamBold", "GothamMedium", "GothamSemibold",
	"Arial", "ArialBold", "Courier", "Roboto", "RobotoMono", "FredokaOne",
	"Arcade", "SciFi", "PermanentMarker", "Jura", "Nunito"
}

local SUPPORTED_CLASSES = {
	"Frame",
	"ScrollingFrame",
	"TextLabel",
	"TextButton",
	"TextBox",
	"ImageLabel",
	"ImageButton"
}

local DEFAULT_PROPERTIES = {
	Frame = {
		Size = {0.15, 0, 0.2, 0},
		Position = {0, 0, 0, 0},
		AnchorPoint = {0, 0},
		BackgroundColor3 = {30, 40, 55},
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BorderColor3 = {0, 0, 0},
		Visible = true,
	},
	ScrollingFrame = {
		Size = {0.15, 0, 0.2, 0},
		Position = {0, 0, 0, 0},
		AnchorPoint = {0, 0},
		BackgroundColor3 = {30, 40, 55},
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BorderColor3 = {0, 0, 0},
		Visible = true,
		CanvasSize = {0, 0, 2, 0},
		ScrollBarThickness = 12,
		ScrollBarImageColor3 = {255, 255, 255},
	},
	TextLabel = {
		Size = {0.15, 0, 0.05, 0},
		Position = {0, 0, 0, 0},
		AnchorPoint = {0, 0},
		BackgroundColor3 = {35, 45, 65},
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BorderColor3 = {0, 0, 0},
		Visible = true,
		Text = "TextLabel",
		TextColor3 = {240, 240, 240},
		TextSize = 14,
		TextTransparency = 0,
		TextWrapped = false,
		Font = "SourceSans",
		TextXAlignment = "Center",
		TextYAlignment = "Center",
	},
	TextButton = {
		Size = {0.12, 0, 0.05, 0},
		Position = {0, 0, 0, 0},
		AnchorPoint = {0, 0},
		BackgroundColor3 = {45, 90, 160},
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BorderColor3 = {0, 0, 0},
		Visible = true,
		Text = "Button",
		TextColor3 = {255, 255, 255},
		TextSize = 14,
		TextTransparency = 0,
		TextWrapped = false,
		Font = "SourceSans",
		TextXAlignment = "Center",
		TextYAlignment = "Center",
	},
	TextBox = {
		Size = {0.12, 0, 0.05, 0},
		Position = {0, 0, 0, 0},
		AnchorPoint = {0, 0},
		BackgroundColor3 = {20, 25, 35},
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BorderColor3 = {0, 0, 0},
		Visible = true,
		Text = "",
		PlaceholderText = "Type here...",
		TextColor3 = {240, 240, 240},
		TextSize = 14,
		TextTransparency = 0,
		TextWrapped = false,
		Font = "SourceSans",
		TextXAlignment = "Center",
		TextYAlignment = "Center",
	},
	ImageLabel = {
		Size = {0.12, 0, 0.15, 0},
		Position = {0, 0, 0, 0},
		AnchorPoint = {0, 0},
		BackgroundColor3 = {255, 255, 255},
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BorderColor3 = {0, 0, 0},
		Visible = true,
		Image = "rbxassetid://0",
		ImageTransparency = 0,
	},
	ImageButton = {
		Size = {0.12, 0, 0.15, 0},
		Position = {0, 0, 0, 0},
		AnchorPoint = {0, 0},
		BackgroundColor3 = {255, 255, 255},
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		BorderColor3 = {0, 0, 0},
		Visible = true,
		Image = "rbxassetid://0",
		ImageTransparency = 0,
	}
}

local SUPPORTED_EVENTS = {
	Frame = {"MouseEnter", "MouseLeave"},
	ScrollingFrame = {"MouseEnter", "MouseLeave"},
	TextLabel = {"MouseEnter", "MouseLeave"},
	TextButton = {"MouseButton1Click", "MouseButton2Click", "MouseEnter", "MouseLeave"},
	TextBox = {"FocusLost", "Focused", "MouseEnter", "MouseLeave"},
	ImageLabel = {"MouseEnter", "MouseLeave"},
	ImageButton = {"MouseButton1Click", "MouseButton2Click", "MouseEnter", "MouseLeave"}
}

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

local function makeBorder(parent, sides)
	local stroke = Instance.new("UIStroke")
	stroke.Color = BORDER_COLOR
	stroke.Thickness = 1
	stroke.Parent = parent
	return stroke
end

local function cloneTable(t)
	local c = {}
	for k, v in pairs(t) do
		if typeof(v) == "table" then
			c[k] = cloneTable(v)
		else
			c[k] = v
		end
	end
	return c
end

local function ensureDefaultProperties(el)
	local defaults = DEFAULT_PROPERTIES[el.class]
	if defaults then
		if not el.properties then el.properties = {} end
		for p, val in pairs(defaults) do
			if el.properties[p] == nil then
				if typeof(val) == "table" then
					el.properties[p] = cloneTable(val)
				else
					el.properties[p] = val
				end
			end
		end
	end
end

local function getUniqueName(elements, baseName)
	local index = 0
	local function exists(name, list)
		for _, el in ipairs(list) do
			if el.name == name then return true end
			if el.children and exists(name, el.children) then return true end
		end
		return false
	end
	
	local currentName = baseName
	while exists(currentName, elements) do
		index += 1
		currentName = baseName .. "_" .. index
	end
	return currentName
end

local function findParentAndIndex(elements, targetId)
	for i, el in ipairs(elements) do
		if el.id == targetId then
			return elements, i
		end
		if el.children then
			local list, index = findParentAndIndex(el.children, targetId)
			if list then return list, index end
		end
	end
	return nil, nil
end

-- Find the parent element of a given element id (returns the parent el or nil for root)
local function findParentEl(elements, targetId, parent)
	for _, el in ipairs(elements) do
		if el.id == targetId then
			return parent
		end
		if el.children then
			local found = findParentEl(el.children, targetId, el)
			if found ~= false then return found end
		end
	end
	return false
end

-- Check if ancestor is an ancestor of el (cycle guard)
local function isAncestor(ancestor, el)
	if not el.children then return false end
	for _, child in ipairs(el.children) do
		if child.id == ancestor.id then return true end
		if isAncestor(ancestor, child) then return true end
	end
	return false
end

local CLASS_ICONS = {
	Frame            = "Fr",
	ScrollingFrame   = "Sc",
	TextLabel        = "Lb",
	TextButton       = "Bt",
	TextBox          = "Bx",
	ImageLabel       = "Im",
	ImageButton      = "Ib",
}
local CLASS_ICON_COLORS = {
	Frame            = Color3.fromRGB(100, 160, 255),
	ScrollingFrame   = Color3.fromRGB(80, 200, 180),
	TextLabel        = Color3.fromRGB(255, 200, 80),
	TextButton       = Color3.fromRGB(120, 230, 120),
	TextBox          = Color3.fromRGB(255, 140, 80),
	ImageLabel       = Color3.fromRGB(200, 130, 255),
	ImageButton      = Color3.fromRGB(255, 100, 150),
}

local function parseColor(str)
	str = str:gsub("%s+", "")
	if str:sub(1, 1) == "#" then
		local hex = str:sub(2)
		if #hex == 6 then
			local r = tonumber(hex:sub(1, 2), 16)
			local g = tonumber(hex:sub(3, 4), 16)
			local b = tonumber(hex:sub(5, 6), 16)
			if r and g and b then
				return {r, g, b}
			end
		end
	else
		local parts = str:split(",")
		if #parts == 3 then
			local r = tonumber(parts[1])
			local g = tonumber(parts[2])
			local b = tonumber(parts[3])
			if r and g and b then
				return {
					math.clamp(math.round(r), 0, 255),
					math.clamp(math.round(g), 0, 255),
					math.clamp(math.round(b), 0, 255)
				}
			end
		end
	end
	return nil
end

local function getVirtualParentSize(self, el)
	local plist, index = findParentAndIndex(self._uiElements, el.id)
	if plist == self._uiElements then
		return Vector2.new(1280, 720)
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
		local inst = self._activeInstances[parentEl.id]
		if inst then
			local scale = self._uiScale and self._uiScale.Scale or 1
			return inst.AbsoluteSize / scale
		end
	end
	return Vector2.new(1280, 720)
end

local function getElementVirtualPixelPos(self, el)
	local curPos = el.properties.Position or {0, 0, 0, 0}
	local parentSize = getVirtualParentSize(self, el)
	local x = curPos[1] * parentSize.X + curPos[2]
	local y = curPos[3] * parentSize.Y + curPos[4]
	return Vector2.new(x, y)
end

local function getElementVirtualPixelSize(self, el)
	local curSize = el.properties.Size or {0, 100, 0, 100}
	local parentSize = getVirtualParentSize(self, el)
	local w = curSize[1] * parentSize.X + curSize[2]
	local h = curSize[3] * parentSize.Y + curSize[4]
	return Vector2.new(w, h)
end

local function getElementUnitMode(el)
	local curSize = el.properties.Size or {0, 100, 0, 100}
	local curPos = el.properties.Position or {0, 0, 0, 0}
	if curSize[1] > 0 or curSize[3] > 0 or curPos[1] > 0 or curPos[3] > 0 then
		return "Scale"
	else
		return "Offset"
	end
end

local function convertElementToScale(self, el)
	local curPos = el.properties.Position or {0, 0, 0, 0}
	local curSize = el.properties.Size or {0, 100, 0, 100}
	local parentSize = getVirtualParentSize(self, el)
	
	-- Calculate absolute pixels
	local absX = curPos[1] * parentSize.X + curPos[2]
	local absY = curPos[3] * parentSize.Y + curPos[4]
	local absW = curSize[1] * parentSize.X + curSize[2]
	local absH = curSize[3] * parentSize.Y + curSize[4]
	
	-- Convert to scale
	local scaleX = absX / parentSize.X
	local scaleY = absY / parentSize.Y
	local scaleW = absW / parentSize.X
	local scaleH = absH / parentSize.Y
	
	el.properties.Position = {scaleX, 0, scaleY, 0}
	el.properties.Size = {scaleW, 0, scaleH, 0}
end

local function convertElementToOffset(self, el)
	local curPos = el.properties.Position or {0, 0, 0, 0}
	local curSize = el.properties.Size or {0, 100, 0, 100}
	local parentSize = getVirtualParentSize(self, el)
	
	-- Calculate absolute pixels
	local absX = curPos[1] * parentSize.X + curPos[2]
	local absY = curPos[3] * parentSize.Y + curPos[4]
	local absW = curSize[1] * parentSize.X + curSize[2]
	local absH = curSize[3] * parentSize.Y + curSize[4]
	
	-- Convert to offset
	el.properties.Position = {0, math.round(absX), 0, math.round(absY)}
	el.properties.Size = {0, math.round(absW), 0, math.round(absH)}
end

local function getElementMockupRelativePos(self, el)
	local curPos = el.properties.Position or {0, 0, 0, 0}
	local parentSize = getVirtualParentSize(self, el)
	local localX = curPos[1] * parentSize.X + curPos[2]
	local localY = curPos[3] * parentSize.Y + curPos[4]
	
	local curAnchor = el.properties.AnchorPoint or {0, 0}
	local elSize = getElementVirtualPixelSize(self, el)
	local localTopLeftX = localX - curAnchor[1] * elSize.X
	local localTopLeftY = localY - curAnchor[2] * elSize.Y
	
	local plist, index = findParentAndIndex(self._uiElements, el.id)
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

local function applyAnchorPreset(self, el, presetName)
	local newAnchor = {0, 0}
	local newPosScale = {0, 0}
	
	if presetName == "Top Left" then
		newAnchor = {0, 0}
		newPosScale = {0, 0}
	elseif presetName == "Top Center" then
		newAnchor = {0.5, 0}
		newPosScale = {0.5, 0}
	elseif presetName == "Top Right" then
		newAnchor = {1, 0}
		newPosScale = {1, 0}
	elseif presetName == "Center Left" then
		newAnchor = {0, 0.5}
		newPosScale = {0, 0.5}
	elseif presetName == "Center" then
		newAnchor = {0.5, 0.5}
		newPosScale = {0.5, 0.5}
	elseif presetName == "Center Right" then
		newAnchor = {1, 0.5}
		newPosScale = {1, 0.5}
	elseif presetName == "Bottom Left" then
		newAnchor = {0, 1}
		newPosScale = {0, 1}
	elseif presetName == "Bottom Center" then
		newAnchor = {0.5, 1}
		newPosScale = {0.5, 1}
	elseif presetName == "Bottom Right" then
		newAnchor = {1, 1}
		newPosScale = {1, 1}
	end
	
	el.properties.AnchorPoint = newAnchor
	el.properties.Position = {newPosScale[1], 0, newPosScale[2], 0}
	
	self:SaveState()
	self:refreshViewport()
	self:refreshDetails()
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

function UiDesigner.new(parent, onSwitchToGraph)
	local self = setmetatable({}, UiDesigner)

	self._widget = parent
	self._onSwitchToGraph = onSwitchToGraph
	self._selectedElement = nil
	self._uiElements = {}
	self._sData = nil
	self._currentGraph = nil
	self._activeColorPickers = {}
	self._isShiftHeld = false
	self._collapsedNodes = {} -- {[el.id] = true}
	-- Hierarchy drag state
	self._hierDragEl = nil
	self._hierDragGhost = nil
	self._hierDragTarget = nil
	self._hierDragMode = nil -- "into"|"before"|"after"
	self._hierDragRows = {} -- list of {el, row, depth, parentList, index}

	UserInputService.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
				self._isShiftHeld = true
			end
		end
	end)

	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Keyboard then
			if input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
				self._isShiftHeld = false
			end
		end
	end)

	-- Main background covering everything below TopBar
	local frame = Instance.new("Frame")
	frame.Name = "UiDesigner"
	frame.Size = UDim2.new(1, 0, 1, -40)
	frame.Position = UDim2.new(0, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(14, 19, 30)
	frame.BorderSizePixel = 0
	frame.Visible = false
	frame.Parent = parent
	self._frame = frame

	-- Left Panel: Palette and Hierarchy
	local leftPanel = Instance.new("Frame")
	leftPanel.Name = "LeftPanel"
	leftPanel.Size = UDim2.new(0, 220, 1, 0)
	leftPanel.Position = UDim2.new(0, 0, 0, 0)
	leftPanel.BackgroundColor3 = PANEL_BG
	leftPanel.BorderSizePixel = 0
	leftPanel.Parent = frame
	makeBorder(leftPanel)

	-- Palette Section (top half of Left Panel)
	local paletteTitle = Instance.new("TextLabel")
	paletteTitle.Size = UDim2.new(1, -24, 0, 30)
	paletteTitle.Position = UDim2.new(0, 12, 0, 0)
	paletteTitle.BackgroundTransparency = 1
	paletteTitle.Text = "PALETTE"
	paletteTitle.TextColor3 = TEXT_COLOR
	paletteTitle.TextSize = 11
	paletteTitle.Font = Enum.Font.GothamBold
	paletteTitle.TextXAlignment = Enum.TextXAlignment.Left
	paletteTitle.Parent = leftPanel

	local paletteScroll = Instance.new("ScrollingFrame")
	paletteScroll.Size = UDim2.new(1, -24, 0.4, -30)
	paletteScroll.Position = UDim2.new(0, 12, 0, 30)
	paletteScroll.BackgroundTransparency = 1
	paletteScroll.BorderSizePixel = 0
	paletteScroll.ScrollBarThickness = 3
	paletteScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 75, 110)
	paletteScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	paletteScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	paletteScroll.Parent = leftPanel
	self._paletteScroll = paletteScroll

	local paletteLayout = Instance.new("UIListLayout")
	paletteLayout.Padding = UDim.new(0, 4)
	paletteLayout.Parent = paletteScroll

	-- Horizontal Separator
	local sep = Instance.new("Frame")
	sep.Size = UDim2.new(1, 0, 0, 1)
	sep.Position = UDim2.new(0, 0, 0.4, 0)
	sep.BackgroundColor3 = BORDER_COLOR
	sep.BorderSizePixel = 0
	sep.Parent = leftPanel

	-- Hierarchy Section (bottom half of Left Panel)
	local hierarchyTitle = Instance.new("TextLabel")
	hierarchyTitle.Size = UDim2.new(1, -24, 0, 30)
	hierarchyTitle.Position = UDim2.new(0, 12, 0.4, 5)
	hierarchyTitle.BackgroundTransparency = 1
	hierarchyTitle.Text = "HIERARCHY"
	hierarchyTitle.TextColor3 = TEXT_COLOR
	hierarchyTitle.TextSize = 11
	hierarchyTitle.Font = Enum.Font.GothamBold
	hierarchyTitle.TextXAlignment = Enum.TextXAlignment.Left
	hierarchyTitle.Parent = leftPanel

	local hierarchyScroll = Instance.new("ScrollingFrame")
	hierarchyScroll.Size = UDim2.new(1, -12, 0.6, -40)
	hierarchyScroll.Position = UDim2.new(0, 6, 0.4, 35)
	hierarchyScroll.BackgroundTransparency = 1
	hierarchyScroll.BorderSizePixel = 0
	hierarchyScroll.ScrollBarThickness = 3
	hierarchyScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 75, 110)
	hierarchyScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	hierarchyScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	hierarchyScroll.Active = false
	hierarchyScroll.Parent = leftPanel
	self._hierarchyScroll = hierarchyScroll

	local hierBg = Instance.new("TextButton")
	hierBg.Name = "HierBg"
	hierBg.Size = UDim2.new(1, 0, 1, 0)
	hierBg.BackgroundTransparency = 1
	hierBg.Text = ""
	hierBg.ZIndex = -10
	hierBg.Parent = leftPanel
	hierBg.MouseButton1Click:Connect(function()
		if self._selectedElement then
			self._selectedElement = nil
			self:refreshHierarchy()
			self:refreshViewport()
			self:refreshDetails()
		end
	end)

	local hierarchyLayout = Instance.new("UIListLayout")
	hierarchyLayout.Padding = UDim.new(0, 2)
	hierarchyLayout.SortOrder = Enum.SortOrder.LayoutOrder
	hierarchyLayout.Parent = hierarchyScroll

	-- Right Panel: Details and Events
	local rightPanel = Instance.new("Frame")
	rightPanel.Name = "RightPanel"
	rightPanel.Size = UDim2.new(0, 280, 1, 0)
	rightPanel.Position = UDim2.new(1, -280, 0, 0)
	rightPanel.BackgroundColor3 = PANEL_BG
	rightPanel.BorderSizePixel = 0
	rightPanel.Parent = frame
	makeBorder(rightPanel)

	-- Details Label
	local detailsTitle = Instance.new("TextLabel")
	detailsTitle.Size = UDim2.new(0.4, 0, 0, 30)
	detailsTitle.Position = UDim2.new(0, 12, 0, 0)
	detailsTitle.BackgroundTransparency = 1
	detailsTitle.Text = "DETAILS"
	detailsTitle.TextColor3 = TEXT_COLOR
	detailsTitle.TextSize = 11
	detailsTitle.Font = Enum.Font.GothamBold
	detailsTitle.TextXAlignment = Enum.TextXAlignment.Left
	detailsTitle.Parent = rightPanel

	-- Unit Mode Toggle (Scale / Offset)
	self._unitMode = "Scale" -- default to Scale
	self._snappingEnabled = true -- default to true

	local snapToggle = Instance.new("TextButton")
	snapToggle.Name = "SnapToggle"
	snapToggle.Size = UDim2.new(0, 50, 0, 20)
	snapToggle.Position = UDim2.new(1, -192, 0, 5)
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

	local toggleBg = Instance.new("Frame")
	toggleBg.Name = "UnitToggle"
	toggleBg.Size = UDim2.new(0, 120, 0, 20)
	toggleBg.Position = UDim2.new(1, -132, 0, 5)
	toggleBg.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	toggleBg.BorderSizePixel = 0
	makeCorner(toggleBg, 4)
	makeBorder(toggleBg)
	toggleBg.Parent = rightPanel

	local scaleBtn = Instance.new("TextButton")
	scaleBtn.Name = "Scale"
	scaleBtn.Size = UDim2.new(0.5, -2, 1, -4)
	scaleBtn.Position = UDim2.new(0, 2, 0, 2)
	scaleBtn.BackgroundColor3 = Color3.fromRGB(38, 70, 120)
	scaleBtn.BorderSizePixel = 0
	scaleBtn.Text = "Scale"
	scaleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	scaleBtn.TextSize = 10
	scaleBtn.Font = Enum.Font.GothamBold
	makeCorner(scaleBtn, 3)
	scaleBtn.Parent = toggleBg
	self._scaleBtn = scaleBtn

	local offsetBtn = Instance.new("TextButton")
	offsetBtn.Name = "Offset"
	offsetBtn.Size = UDim2.new(0.5, -2, 1, -4)
	offsetBtn.Position = UDim2.new(0.5, 0, 0, 2)
	offsetBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
	offsetBtn.BorderSizePixel = 0
	offsetBtn.Text = "Offset"
	offsetBtn.TextColor3 = Color3.fromRGB(130, 150, 180)
	offsetBtn.TextSize = 10
	offsetBtn.Font = Enum.Font.GothamMedium
	makeCorner(offsetBtn, 3)
	offsetBtn.Parent = toggleBg
	self._offsetBtn = offsetBtn

	scaleBtn.MouseButton1Click:Connect(function()
		self._unitMode = "Scale"
		self:updateToggleVisuals()
		if self._selectedElement then
			convertElementToScale(self, self._selectedElement)
			self:SaveState()
			self:refreshViewport()
			self:refreshDetails()
		end
	end)

	offsetBtn.MouseButton1Click:Connect(function()
		self._unitMode = "Offset"
		self:updateToggleVisuals()
		if self._selectedElement then
			convertElementToOffset(self, self._selectedElement)
			self:SaveState()
			self:refreshViewport()
			self:refreshDetails()
		end
	end)

	local propertiesScroll = Instance.new("ScrollingFrame")
	propertiesScroll.Size = UDim2.new(1, -24, 0.6, -30)
	propertiesScroll.Position = UDim2.new(0, 12, 0, 30)
	propertiesScroll.BackgroundTransparency = 1
	propertiesScroll.BorderSizePixel = 0
	propertiesScroll.ScrollBarThickness = 3
	propertiesScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 75, 110)
	propertiesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	propertiesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	propertiesScroll.Parent = rightPanel
	self._propertiesScroll = propertiesScroll

	local propertiesLayout = Instance.new("UIListLayout")
	propertiesLayout.Padding = UDim.new(0, 8)
	propertiesLayout.Parent = propertiesScroll

	-- Horizontal Separator 2
	local sep2 = Instance.new("Frame")
	sep2.Size = UDim2.new(1, 0, 0, 1)
	sep2.Position = UDim2.new(0, 0, 0.6, 0)
	sep2.BackgroundColor3 = BORDER_COLOR
	sep2.BorderSizePixel = 0
	sep2.Parent = rightPanel

	-- Events Header
	local eventsTitle = Instance.new("TextLabel")
	eventsTitle.Size = UDim2.new(1, -24, 0, 30)
	eventsTitle.Position = UDim2.new(0, 12, 0.6, 5)
	eventsTitle.BackgroundTransparency = 1
	eventsTitle.Text = "EVENTS"
	eventsTitle.TextColor3 = TEXT_COLOR
	eventsTitle.TextSize = 11
	eventsTitle.Font = Enum.Font.GothamBold
	eventsTitle.TextXAlignment = Enum.TextXAlignment.Left
	eventsTitle.Parent = rightPanel

	local eventsScroll = Instance.new("ScrollingFrame")
	eventsScroll.Size = UDim2.new(1, -24, 0.4, -40)
	eventsScroll.Position = UDim2.new(0, 12, 0.6, 35)
	eventsScroll.BackgroundTransparency = 1
	eventsScroll.BorderSizePixel = 0
	eventsScroll.ScrollBarThickness = 3
	eventsScroll.ScrollBarImageColor3 = Color3.fromRGB(60, 75, 110)
	eventsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	eventsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	eventsScroll.Parent = rightPanel
	self._eventsScroll = eventsScroll

	local eventsLayout = Instance.new("UIListLayout")
	eventsLayout.Padding = UDim.new(0, 4)
	eventsLayout.Parent = eventsScroll

	-- Center Viewport Panel
	local centerPanel = Instance.new("Frame")
	centerPanel.Name = "CenterPanel"
	centerPanel.Size = UDim2.new(1, -500, 1, 0)
	centerPanel.Position = UDim2.new(0, 220, 0, 0)
	centerPanel.BackgroundColor3 = VIEWPORT_BG
	centerPanel.BorderSizePixel = 0
	centerPanel.ClipsDescendants = true
	centerPanel.Parent = frame

	-- Draw Center Panel Dot Grid (simple dots tiling layout)
	local centerGrid = Instance.new("Frame")
	centerGrid.Name = "DotGrid"
	centerGrid.Size = UDim2.new(1, 0, 1, 0)
	centerGrid.BackgroundTransparency = 1
	centerGrid.Parent = centerPanel

	local function updateMockupScale()
		local containerSize = centerPanel.AbsoluteSize
		if containerSize.X <= 0 or containerSize.Y <= 0 then return end
		
		local targetW = 1280
		local targetH = 720
		local padding = 40
		local maxW = math.max(100, containerSize.X - padding)
		local maxH = math.max(100, containerSize.Y - padding)
		
		local scaleX = maxW / targetW
		local scaleY = maxH / targetH
		local scale = math.min(scaleX, scaleY)
		
		self._uiScale.Scale = scale
	end

	local function makeGrid()
		for _, child in centerGrid:GetChildren() do child:Destroy() end
		local size = centerPanel.AbsoluteSize
		if size.X <= 0 then return end
		local spacing = 32
		for x = 0, size.X, spacing do
			for y = 0, size.Y, spacing do
				local d = Instance.new("Frame")
				d.Size = UDim2.fromOffset(2, 2)
				d.Position = UDim2.fromOffset(x, y)
				d.BackgroundColor3 = Color3.fromRGB(42, 58, 85)
				d.BorderSizePixel = 0
				makeCorner(d, 1)
				d.Parent = centerGrid
			end
		end
	end

	local function updateAll()
		makeGrid()
		updateMockupScale()
	end
	
	task.defer(updateAll)
	centerPanel:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateAll)

	-- Viewport mockup container (represents the screen)
	local viewportMockup = Instance.new("Frame")
	viewportMockup.Name = "ViewportMockup"
	viewportMockup.Size = UDim2.new(0, 1280, 0, 720)
	viewportMockup.AnchorPoint = Vector2.new(0.5, 0.5)
	viewportMockup.Position = UDim2.new(0.5, 0, 0.5, 0)
	viewportMockup.BackgroundColor3 = Color3.fromRGB(15, 18, 25)
	viewportMockup.BorderSizePixel = 0
	viewportMockup.ClipsDescendants = true
	viewportMockup.Parent = centerPanel
	self._viewportMockup = viewportMockup

	local vpBg = Instance.new("TextButton")
	vpBg.Name = "VpBg"
	vpBg.Size = UDim2.new(1, 0, 1, 0)
	vpBg.BackgroundTransparency = 1
	vpBg.Text = ""
	vpBg.ZIndex = -10
	vpBg.Parent = viewportMockup
	vpBg.MouseButton1Click:Connect(function()
		if self._selectedElement then
			self._selectedElement = nil
			self:refreshHierarchy()
			self:refreshViewport()
			self:refreshDetails()
		end
	end)

	local uiScale = Instance.new("UIScale")
	uiScale.Parent = viewportMockup
	self._uiScale = uiScale

	local mockupStroke = Instance.new("UIStroke")
	mockupStroke.Color = BORDER_COLOR
	mockupStroke.Thickness = 2
	mockupStroke.Parent = viewportMockup

	-- Title on top of screen
	local viewportLabel = Instance.new("TextLabel")
	viewportLabel.Size = UDim2.new(1, 0, 0, 20)
	viewportLabel.Position = UDim2.new(0, 8, 0, 8)
	viewportLabel.BackgroundTransparency = 1
	viewportLabel.Text = "Mockup Screen Viewport (16:9)"
	viewportLabel.TextColor3 = Color3.fromRGB(80, 100, 140)
	viewportLabel.TextSize = 10
	viewportLabel.Font = Enum.Font.GothamBold
	viewportLabel.TextXAlignment = Enum.TextXAlignment.Left
	viewportLabel.ZIndex = 2
	viewportLabel.Parent = viewportMockup

	-- Drag & Drop state
	self._activeInstances = {}
	self._isDragging = false
	self._draggedElement = nil
	self._draggedInstance = nil
	self._dragStartMousePos = nil
	self._dragStartElementPos = nil

	-- Resize state
	self._isResizing = false
	self._resizedElement = nil
	self._resizedInstance = nil
	self._resizeStartMousePos = nil
	self._resizeStartElementSize = nil
	self._resizeStartElementPos = nil
	self._resizeHandleType = nil

	-- Local Mouse Drag & Resize Listeners connected to frame
	frame.InputChanged:Connect(function(input)
		if not frame.Visible then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			local scale = self._uiScale and self._uiScale.Scale or 1
			
			-- Handle Slider Dragging first
			if self._activeSliderDrag then
				local mouseX = input.Position.X
				local track = self._activeSliderDrag.track
				local relativeX = mouseX - track.AbsolutePosition.X
				local pct = math.clamp(relativeX / track.AbsoluteSize.X, 0, 1)
				self._activeSliderDrag.sHandle.Position = UDim2.new(pct, 0, 0.5, 0)
				self._activeSliderDrag.sFill.Size = UDim2.new(pct, 0, 1, 0)
				local val = math.round(pct * 255)
				self._activeSliderDrag.sVal.Text = tostring(val)
				self._activeSliderDrag.onChanged(val)
				return
			end

			if self._isDragging and self._draggedElement then
				local mousePos = input.Position
				local delta = (mousePos - self._dragStartMousePos) / scale

				-- Shift key dominant axis lock
				local isShift = self._isShiftHeld or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
				if isShift then
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
				local elSize = getElementVirtualPixelSize(self, el)
				local anchor = el.properties.AnchorPoint or {0, 0}

				-- Calculate the visual local boundaries
				local visualX = newX - anchor[1] * elSize.X
				local visualY = newY - anchor[2] * elSize.Y

				local snappedX = false
				local snappedY = false

				if self._snappingEnabled ~= false then
					local threshold = 12

					-- Find parent's mockup-relative top-left position and the parent's children list
					local parentMockupPos = Vector2.new(0, 0)
					local plist, index = findParentAndIndex(self._uiElements, el.id)
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

					-- Gather all snap targets (mockup-relative coordinates)
					local xTargets = {}
					local yTargets = {}

					-- 1. Parent Canvas targets
					local parentW = parentSize.X
					local parentH = parentSize.Y
					table.insert(xTargets, parentMockupPos.X)             -- Left
					table.insert(xTargets, parentMockupPos.X + parentW / 2) -- Center
					table.insert(xTargets, parentMockupPos.X + parentW)     -- Right

					table.insert(yTargets, parentMockupPos.Y)             -- Top
					table.insert(yTargets, parentMockupPos.Y + parentH / 2) -- Center
					table.insert(yTargets, parentMockupPos.Y + parentH)     -- Bottom

					-- 2. All other elements targets
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

					-- Current mockup-relative coordinates of dragged element
					local mockupTopLeft = parentMockupPos + Vector2.new(visualX, visualY)

					-- Find best X snap
					local bestDiffX = threshold
					local bestTargetX = nil
					local snapTypeX = nil -- "left", "center", "right"

					for _, targetX in ipairs(xTargets) do
						-- Check Left snap
						local diffL = math.abs(mockupTopLeft.X - targetX)
						if diffL < bestDiffX then
							bestDiffX = diffL
							bestTargetX = targetX
							snapTypeX = "left"
						end
						-- Check Center snap
						local diffC = math.abs((mockupTopLeft.X + elSize.X / 2) - targetX)
						if diffC < bestDiffX then
							bestDiffX = diffC
							bestTargetX = targetX
							snapTypeX = "center"
						end
						-- Check Right snap
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

					-- Find best Y snap
					local bestDiffY = threshold
					local bestTargetY = nil
					local snapTypeY = nil -- "top", "center", "bottom"

					for _, targetY in ipairs(yTargets) do
						-- Check Top snap
						local diffT = math.abs(mockupTopLeft.Y - targetY)
						if diffT < bestDiffY then
							bestDiffY = diffT
							bestTargetY = targetY
							snapTypeY = "top"
						end
						-- Check Center snap
						local diffC = math.abs((mockupTopLeft.Y + elSize.Y / 2) - targetY)
						if diffC < bestDiffY then
							bestDiffY = diffC
							bestTargetY = targetY
							snapTypeY = "center"
						end
						-- Check Bottom snap
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

				if self._unitMode == "Scale" then
					local scaleX = newX / parentSize.X
					local scaleY = newY / parentSize.Y
					el.properties.Position = {scaleX, 0, scaleY, 0}
				else
					el.properties.Position = {0, math.round(newX), 0, math.round(newY)}
				end

				if self._draggedInstance then
					self._draggedInstance.Position = UDim2.new(unpack(el.properties.Position))
				end
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
				
				-- Minimum limit of 5x5
				if newW < 5 then
					if handle == "BL" or handle == "TL" then
						newX = startX + (startW - 5)
					end
					newW = 5
				end
				if newH < 5 then
					if handle == "TR" or handle == "TL" then
						newY = startY + (startH - 5)
					end
					newH = 5
				end

				local el = self._resizedElement
				local parentSize = getVirtualParentSize(self, el)

				if self._unitMode == "Scale" then
					local scaleW = newW / parentSize.X
					local scaleH = newH / parentSize.Y
					local scaleX = newX / parentSize.X
					local scaleY = newY / parentSize.Y
					el.properties.Size = {scaleW, 0, scaleH, 0}
					el.properties.Position = {scaleX, 0, scaleY, 0}
				else
					el.properties.Size = {0, math.round(newW), 0, math.round(newH)}
					el.properties.Position = {0, math.round(newX), 0, math.round(newY)}
				end

				if self._resizedInstance then
					self._resizedInstance.Size = UDim2.new(unpack(el.properties.Size))
					self._resizedInstance.Position = UDim2.new(unpack(el.properties.Position))
				end
			end
		end
	end)

	-- Delete key listener
	UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
		if gameProcessedEvent then return end
		if not frame.Visible then return end
		if not self._selectedElement then return end

		if input.KeyCode == Enum.KeyCode.Delete or input.KeyCode == Enum.KeyCode.Backspace then
			if UserInputService:GetFocusedTextBox() then return end
			self:deleteElement(self._selectedElement)
		end
	end)

	self:buildPalette()
	return self
end

function UiDesigner:buildPalette()
	for _, className in ipairs(SUPPORTED_CLASSES) do
		local btn = Instance.new("TextButton")
		btn.Name = className .. "PaletteBtn"
		btn.Size = UDim2.new(1, 0, 0, 26)
		btn.BackgroundColor3 = Color3.fromRGB(28, 38, 58)
		btn.BorderSizePixel = 0
		btn.Text = "  + " .. className
		btn.TextColor3 = Color3.fromRGB(150, 180, 240)
		btn.TextSize = 12
		btn.Font = Enum.Font.GothamMedium
		btn.TextXAlignment = Enum.TextXAlignment.Left
		btn.AutoButtonColor = true
		makeCorner(btn, 4)
		btn.Parent = self._paletteScroll

		btn.MouseButton1Click:Connect(function()
			self:addNewElement(className)
		end)
	end
end

function UiDesigner:LoadScript(sData, graph)
	self._sData = sData
	self._uiElements = sData.uiElements or {}
	self._currentGraph = graph
	self._selectedElement = nil
	
	self:refreshAll()
end

function UiDesigner:SaveState()
	if self._sData then
		self._sData.uiElements = self._uiElements
	end
end

function UiDesigner:deleteElement(el)
	if not el then return end
	local plist, index = findParentAndIndex(self._uiElements, el.id)
	if plist and index then
		-- If deleting a node, also delete event nodes in graph if user renames/deletes
		if self._currentGraph then
			local toRemove = {}
			for _, node in pairs(self._currentGraph.nodes) do
				if node.Class and string.sub(node.Class, 1, 8) == "UIEvent:" then
					local parts = string.split(node.Class, ":")
					if parts[2] == el.name then
						table.insert(toRemove, node)
					end
				end
			end
			for _, node in ipairs(toRemove) do
				self._currentGraph:remove_node(node)
			end
		end
		
		table.remove(plist, index)
		if self._selectedElement == el then
			self._selectedElement = nil
		end
		self:SaveState()
		self:refreshAll()
	end
end

function UiDesigner:addNewElement(className)
	if not self._sData then return end
	
	local flattened = {}
	local function flatten(list)
		for _, el in ipairs(list) do
			table.insert(flattened, el)
			if el.children then flatten(el.children) end
		end
	end
	flatten(self._uiElements)

	local name = getUniqueName(self._uiElements, className)
	local defaultProps = cloneTable(DEFAULT_PROPERTIES[className])

	local newEl = {
		id = "el_" .. HttpService:GenerateGUID(false):gsub("-", ""),
		name = name,
		class = className,
		properties = defaultProps,
		children = {}
	}

	if self._selectedElement then
		-- Parent to currently selected element
		table.insert(self._selectedElement.children, newEl)
	else
		-- Root-level
		table.insert(self._uiElements, newEl)
	end

	self._selectedElement = newEl
	self:SaveState()
	self:refreshAll()
end

function UiDesigner:updateToggleVisuals()
	if not self._scaleBtn or not self._offsetBtn then return end
	if self._unitMode == "Scale" then
		self._scaleBtn.BackgroundColor3 = Color3.fromRGB(38, 70, 120)
		self._scaleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		self._scaleBtn.Font = Enum.Font.GothamBold

		self._offsetBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
		self._offsetBtn.TextColor3 = Color3.fromRGB(130, 150, 180)
		self._offsetBtn.Font = Enum.Font.GothamMedium
	else
		self._scaleBtn.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
		self._scaleBtn.TextColor3 = Color3.fromRGB(130, 150, 180)
		self._scaleBtn.Font = Enum.Font.GothamMedium

		self._offsetBtn.BackgroundColor3 = Color3.fromRGB(38, 70, 120)
		self._offsetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		self._offsetBtn.Font = Enum.Font.GothamBold
	end
end

function UiDesigner:refreshAll()
	self:refreshHierarchy()
	self:refreshViewport()
	self:refreshDetails()
end

function UiDesigner:refreshHierarchy()
	local leftPanel = self._hierarchyScroll.Parent

	-- Clean old rows
	for _, child in self._hierarchyScroll:GetChildren() do
		if child:IsA("GuiObject") then child:Destroy() end
	end
	-- Clean overlay elements parented to leftPanel
	if self._hierDragGhost and self._hierDragGhost.Parent then
		self._hierDragGhost:Destroy()
	end
	self._hierDragGhost = nil
	if self._hierHoverOverlay and self._hierHoverOverlay.Parent then
		self._hierHoverOverlay:Destroy()
	end
	self._hierHoverOverlay = nil
	self._hierDragEl = nil
	self._hierDragTarget = nil
	self._hierDragMode = nil

	-- Build flat ordered list respecting collapse state
	local list = {}
	local function flatten(elements, depth, parentList)
		for idx, el in ipairs(elements) do
			table.insert(list, {el = el, depth = depth, parentList = parentList, index = idx})
			local hasChildren = el.children and #el.children > 0
			if hasChildren and not self._collapsedNodes[el.id] then
				flatten(el.children, depth + 1, el.children)
			end
		end
	end
	flatten(self._uiElements, 0, self._uiElements)

	-- Hover/drop overlay parented to leftPanel (avoids UIListLayout interference)
	local hoverOverlay = Instance.new("Frame")
	hoverOverlay.Name = "HierHoverOverlay"
	hoverOverlay.Visible = false
	hoverOverlay.ZIndex = 30
	hoverOverlay.Active = false -- transparent to input
	hoverOverlay.BorderSizePixel = 0
	makeCorner(hoverOverlay, 3)
	hoverOverlay.Parent = leftPanel
	self._hierHoverOverlay = hoverOverlay

	local ROW_H = 28

	for rowIdx, item in ipairs(list) do
		local isSel    = self._selectedElement == item.el
		local hasChildren = item.el.children and #item.el.children > 0
		local isCollapsed = self._collapsedNodes[item.el.id]
		local indent   = item.depth * 14

		-- Row container - LayoutOrder ensures correct visual order
		local row = Instance.new("Frame")
		row.Name = "HierRow_" .. item.el.id
		row.LayoutOrder = rowIdx  -- <- fixes ordering bug
		row.Size = UDim2.new(1, 0, 0, ROW_H)
		row.BackgroundTransparency = 1
		row.Parent = self._hierarchyScroll

		-- Alternating background
		local rowBg = Instance.new("Frame")
		rowBg.Size = UDim2.new(1, 0, 1, 0)
		rowBg.BackgroundColor3 = (rowIdx % 2 == 0)
			and Color3.fromRGB(18, 23, 36)
			or  Color3.fromRGB(14, 19, 30)
		rowBg.BackgroundTransparency = 0.45
		rowBg.BorderSizePixel = 0
		rowBg.ZIndex = 1
		rowBg.Parent = row

		-- Vertical indentation guides
		for d = 0, item.depth - 1 do
			local guide = Instance.new("Frame")
			guide.Size = UDim2.new(0, 1, 1, 0)
			guide.Position = UDim2.fromOffset(8 + d * 14 + 6, 0)
			guide.BackgroundColor3 = Color3.fromRGB(50, 65, 95)
			guide.BorderSizePixel = 0
			guide.ZIndex = 2
			guide.Parent = row
		end

		-- Chevron expand/collapse
		local chevronBtn = Instance.new("TextButton")
		chevronBtn.Size = UDim2.fromOffset(16, 16)
		chevronBtn.Position = UDim2.new(0, indent + 4, 0.5, -8)
		chevronBtn.BackgroundTransparency = 1
		chevronBtn.Text = hasChildren and (isCollapsed and ">" or "v") or ""
		chevronBtn.TextColor3 = Color3.fromRGB(100, 130, 180)
		chevronBtn.TextSize = 9
		chevronBtn.Font = Enum.Font.GothamBold
		chevronBtn.ZIndex = 5
		chevronBtn.Parent = row

		chevronBtn.MouseButton1Click:Connect(function()
			if hasChildren then
				if isCollapsed then
					self._collapsedNodes[item.el.id] = nil
				else
					self._collapsedNodes[item.el.id] = true
				end
				self:refreshHierarchy()
			end
		end)

		-- Class icon badge
		local iconLabel = Instance.new("TextLabel")
		iconLabel.Size = UDim2.fromOffset(18, 18)
		iconLabel.Position = UDim2.new(0, indent + 22, 0.5, -9)
		iconLabel.BackgroundColor3 = (CLASS_ICON_COLORS[item.el.class] or Color3.fromRGB(100, 120, 160)):Lerp(Color3.fromRGB(0,0,0), 0.55)
		iconLabel.BackgroundTransparency = 0
		iconLabel.Text = CLASS_ICONS[item.el.class] or "?"
		iconLabel.TextColor3 = CLASS_ICON_COLORS[item.el.class] or Color3.fromRGB(180, 200, 230)
		iconLabel.TextSize = 9
		iconLabel.Font = Enum.Font.GothamBold
		iconLabel.ZIndex = 5
		makeCorner(iconLabel, 3)
		iconLabel.Parent = row

		-- Selection highlight
		if isSel then
			local selHL = Instance.new("Frame")
			selHL.Size = UDim2.new(1, -4, 1, -2)
			selHL.Position = UDim2.new(0, 2, 0, 1)
			selHL.BackgroundColor3 = Color3.fromRGB(38, 70, 140)
			selHL.BackgroundTransparency = 0.2
			selHL.BorderSizePixel = 0
			selHL.ZIndex = 3
			makeCorner(selHL, 4)
			selHL.Parent = row
			local selStroke = Instance.new("UIStroke")
			selStroke.Color = Color3.fromRGB(80, 150, 255)
			selStroke.Thickness = 1
			selStroke.Parent = selHL
		end

		-- Name button (click area + drag source)
		local nameBtn = Instance.new("TextButton")
		nameBtn.Size = UDim2.new(1, -(indent + 44 + 24), 1, -2)
		nameBtn.Position = UDim2.new(0, indent + 44, 0, 1)
		nameBtn.BackgroundTransparency = 1
		nameBtn.Text = item.el.name
		nameBtn.TextColor3 = isSel and Color3.fromRGB(220, 235, 255) or Color3.fromRGB(160, 180, 215)
		nameBtn.TextSize = 11
		nameBtn.Font = isSel and Enum.Font.GothamBold or Enum.Font.GothamMedium
		nameBtn.TextXAlignment = Enum.TextXAlignment.Left
		nameBtn.ZIndex = 5
		nameBtn.Parent = row

		-- Class badge (right-aligned)
		local classBadge = Instance.new("TextLabel")
		classBadge.Size = UDim2.fromOffset(78, 15)
		classBadge.Position = UDim2.new(1, -102, 0.5, -7)
		classBadge.BackgroundColor3 = Color3.fromRGB(20, 28, 44)
		classBadge.BackgroundTransparency = 0.25
		classBadge.Text = item.el.class
		classBadge.TextColor3 = (CLASS_ICON_COLORS[item.el.class] or Color3.fromRGB(120, 140, 170)):Lerp(Color3.fromRGB(255,255,255), 0.15)
		classBadge.TextSize = 9
		classBadge.Font = Enum.Font.GothamMedium
		classBadge.ZIndex = 5
		makeCorner(classBadge, 3)
		classBadge.Parent = row

		-- Delete button
		local delBtn = Instance.new("TextButton")
		delBtn.Size = UDim2.fromOffset(18, 18)
		delBtn.Position = UDim2.new(1, -21, 0.5, -9)
		delBtn.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
		delBtn.BackgroundTransparency = 0.35
		delBtn.Text = "x"
		delBtn.TextColor3 = Color3.fromRGB(230, 90, 90)
		delBtn.TextSize = 9
		delBtn.Font = Enum.Font.GothamBold
		delBtn.ZIndex = 6
		makeCorner(delBtn, 4)
		delBtn.Parent = row

		delBtn.MouseButton1Click:Connect(function()
			self:deleteElement(item.el)
		end)

		-- ==========================================================
		-- Drag-and-Drop + Select (unified handler)
		-- ==========================================================
		local dragStarted = false
		local startMouseY = 0
		local dragConn, releaseConn

		nameBtn.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
			dragStarted = false
			startMouseY = input.Position.Y

			-- Ghost label (parented to leftPanel - no UIListLayout here)
			local ghost = Instance.new("TextLabel")
			ghost.Size = UDim2.new(1, -16, 0, 24)
			ghost.Position = UDim2.fromOffset(8, 0)
			ghost.BackgroundColor3 = Color3.fromRGB(45, 85, 155)
			ghost.BackgroundTransparency = 0.25
			ghost.Text = "  [" .. (CLASS_ICONS[item.el.class] or "?") .. "]  " .. item.el.name
			ghost.TextColor3 = Color3.fromRGB(215, 232, 255)
			ghost.TextSize = 11
			ghost.Font = Enum.Font.GothamBold
			ghost.TextXAlignment = Enum.TextXAlignment.Left
			ghost.ZIndex = 40
			ghost.Visible = false
			ghost.Active = false
			makeCorner(ghost, 4)
			local ghostStroke = Instance.new("UIStroke")
			ghostStroke.Color = Color3.fromRGB(80, 150, 255)
			ghostStroke.Thickness = 1
			ghostStroke.Parent = ghost
			ghost.Parent = leftPanel
			self._hierDragGhost = ghost
			self._hierDragEl = item.el

			dragConn = self._frame.InputChanged:Connect(function(moveInput)
				if moveInput.UserInputType ~= Enum.UserInputType.MouseMovement then return end

				local dy = math.abs(moveInput.Position.Y - startMouseY)
				if dy > 5 then dragStarted = true end
				if not dragStarted then return end

				-- Position ghost in leftPanel space
				local panelAbsY = leftPanel.AbsolutePosition.Y
				ghost.Position = UDim2.fromOffset(8, moveInput.Position.Y - panelAbsY - 12)
				ghost.Visible = true

				-- Find hovered row
				local best, bestMode = nil, "into"
				local bestRowAbsY, bestRowH = 0, ROW_H

				for _, ritem in ipairs(list) do
					if ritem.el.id == item.el.id then continue end
					local rrow = self._hierarchyScroll:FindFirstChild("HierRow_" .. ritem.el.id)
					if not rrow then continue end
					local rAbsY = rrow.AbsolutePosition.Y
					local rH    = rrow.AbsoluteSize.Y
					local mAbsY = moveInput.Position.Y
					if mAbsY >= rAbsY and mAbsY < rAbsY + rH then
						best = ritem
						bestRowAbsY = rAbsY
						bestRowH = rH
						local third = rH / 3
						local localY = mAbsY - rAbsY
						if localY < third then
							bestMode = "before"
						elseif localY > third * 2 then
							bestMode = "after"
						else
							bestMode = "into"
						end
						break
					end
				end

				self._hierDragTarget = best
				self._hierDragMode   = bestMode

				-- Update hover overlay (in leftPanel space)
				if best then
					local panelAbsY2 = leftPanel.AbsolutePosition.Y
					local scrollX    = self._hierarchyScroll.AbsolutePosition.X - leftPanel.AbsolutePosition.X
					local scrollW    = self._hierarchyScroll.AbsoluteSize.X
					local relRowY    = bestRowAbsY - panelAbsY2

					if bestMode == "into" then
						hoverOverlay.Size = UDim2.fromOffset(scrollW - 6, bestRowH - 2)
						hoverOverlay.Position = UDim2.fromOffset(scrollX + 3, relRowY + 1)
						hoverOverlay.BackgroundColor3 = Color3.fromRGB(45, 115, 70)
						hoverOverlay.BackgroundTransparency = 0.45
					else
						local lineY = bestMode == "before" and relRowY or relRowY + bestRowH
						hoverOverlay.Size = UDim2.fromOffset(scrollW - 6, 2)
						hoverOverlay.Position = UDim2.fromOffset(scrollX + 3, lineY - 1)
						hoverOverlay.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
						hoverOverlay.BackgroundTransparency = 0
					end
					hoverOverlay.Visible = true
				else
					hoverOverlay.Visible = false
				end
			end)

			releaseConn = input.Changed:Connect(function()
				if input.UserInputState ~= Enum.UserInputState.End then return end
				if dragConn    then dragConn:Disconnect()    dragConn    = nil end
				if releaseConn then releaseConn:Disconnect() releaseConn = nil end

				-- Cleanup ghost & overlay
				if self._hierDragGhost then
					self._hierDragGhost:Destroy()
					self._hierDragGhost = nil
				end
				if self._hierHoverOverlay then
					self._hierHoverOverlay.Visible = false
				end

				if not dragStarted then
					-- Simple click -> select
					self._selectedElement = item.el
					self:refreshHierarchy()
					self:refreshViewport()
					self:refreshDetails()
					return
				end

				-- Apply drag operation
				if not self._hierDragEl then return end
				if not self._hierDragTarget then
					self._hierDragEl = nil
					return
				end

				local dragEl = self._hierDragEl
				local target = self._hierDragTarget
				local mode   = self._hierDragMode or "into"

				-- Cycle guard
				if target.el.id == dragEl.id then return end
				if isAncestor(target.el, dragEl) then return end

				-- Remove from current parent
				local srcList, srcIdx = findParentAndIndex(self._uiElements, dragEl.id)
				if not srcList then return end
				table.remove(srcList, srcIdx)

				-- Re-find target after removal (indices may shift)
				local dstList, dstIdx = findParentAndIndex(self._uiElements, target.el.id)
				if not dstList then
					table.insert(srcList, srcIdx, dragEl)
					return
				end

				if mode == "into" then
					local function findEl(elements, id)
						for _, e in ipairs(elements) do
							if e.id == id then return e end
							if e.children then
								local found = findEl(e.children, id)
								if found then return found end
							end
						end
					end
					local targetEl = findEl(self._uiElements, target.el.id)
					if not targetEl then
						table.insert(srcList, srcIdx, dragEl)
						return
					end
					if not targetEl.children then targetEl.children = {} end
					table.insert(targetEl.children, dragEl)
				elseif mode == "before" then
					table.insert(dstList, dstIdx, dragEl)
				elseif mode == "after" then
					table.insert(dstList, dstIdx + 1, dragEl)
				end

				self._hierDragEl = nil
				self._hierDragTarget = nil
				self._hierDragMode = nil
				self:SaveState()
				self:refreshAll()
			end)
		end)
	end
end
	

function UiDesigner:refreshViewport()
	-- Clean mockup screen
	self._activeInstances = {}
	for _, child in self._viewportMockup:GetChildren() do
		if child:IsA("GuiObject") and child.Name ~= "ViewportLabel" then
			child:Destroy()
		end
	end

	local function buildLiveGui(elements, parentGui)
		for _, el in ipairs(elements) do
			ensureDefaultProperties(el)
			local inst = Instance.new(el.class)
			inst.Name = el.name
			inst.ZIndex = 2
			self._activeInstances[el.id] = inst
			
			-- Apply properties
			for p, val in pairs(el.properties or {}) do
				if p == "Position" then
					inst.Position = UDim2.new(unpack(val))
				elseif p == "Size" then
					inst.Size = UDim2.new(unpack(val))
				elseif p == "CanvasSize" then
					inst.CanvasSize = UDim2.new(unpack(val))
				elseif p == "AnchorPoint" then
					inst.AnchorPoint = Vector2.new(unpack(val))
				elseif p == "BackgroundColor3" or p == "BorderColor3" or p == "TextColor3" or p == "ScrollBarImageColor3" then
					inst[p] = Color3.fromRGB(val[1], val[2], val[3])
				elseif p == "Visible" or p == "TextWrapped" then
					inst[p] = val
				elseif p == "Text" or p == "PlaceholderText" or p == "Image" then
					inst[p] = val
				elseif p == "TextSize" or p == "BackgroundTransparency" or p == "BorderSizePixel" or p == "TextTransparency" or p == "ScrollBarThickness" or p == "ImageTransparency" then
					inst[p] = val
				elseif p == "Font" or p == "TextXAlignment" or p == "TextYAlignment" then
					inst[p] = Enum[p][val]
				end
			end
			
			inst.Parent = parentGui

			-- Invisible hit block for drag-and-drop
			local hitbox = Instance.new("TextButton")
			hitbox.Name = "Hitbox"
			hitbox.Size = UDim2.new(1, 0, 1, 0)
			hitbox.BackgroundTransparency = 1
			hitbox.Text = ""
			hitbox.ZIndex = 1
			hitbox.Parent = inst

			self:hookUpHitbox(el, hitbox, inst)

			-- Recurse children
			if el.children and #el.children > 0 then
				buildLiveGui(el.children, inst)
			end
		end
	end

	buildLiveGui(self._uiElements, self._viewportMockup)
	self:updateSelectionOutline()
end

function UiDesigner:updateSelectionOutline()
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

	-- Reset ZIndex of all active instances to 2
	for _, activeInst in pairs(self._activeInstances) do
		activeInst.ZIndex = 2
	end

	local el = self._selectedElement
	if not el then return end

	local inst = self._activeInstances[el.id]
	if not inst then return end

	-- Boost selected instance ZIndex so outline & handles are drawn on top
	inst.ZIndex = 10000

	-- Draw selection outline
	local outline = Instance.new("UIStroke")
	outline.Name = "SelectionOutline"
	outline.Color = Color3.fromRGB(45, 130, 240)
	outline.Thickness = 2
	outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	outline.Parent = inst

	-- Create the 4 corner handles
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
		handle.BackgroundColor3 = Color3.fromRGB(45, 130, 240)
		handle.BorderSizePixel = 0
		handle.Text = ""
		handle.ZIndex = 1001 -- higher than hitbox
		handle.Active = true
		makeCorner(handle, 2)
		handle.Parent = inst

		handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				self._isResizing = true
				self._resizedElement = el
				self._resizedInstance = inst
				self._resizeHandleType = name
				self._resizeStartMousePos = input.Position
				self._resizeStartElementSize = getElementVirtualPixelSize(self, el)
				self._resizeStartElementPos = getElementVirtualPixelPos(self, el)

				local endConn
				endConn = input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						self._isResizing = false
						self._resizedElement = nil
						self._resizedInstance = nil
						self._resizeHandleType = nil
						self:SaveState()
						self:refreshViewport()
						self:refreshDetails()
						endConn:Disconnect()
					end
				end)
			end
		end)
	end
end

function UiDesigner:hookUpHitbox(el, hitbox, inst)
	hitbox.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			self._selectedElement = el
			self:refreshHierarchy()
			self:updateSelectionOutline()
			self:refreshDetails()

			self._isDragging = true
			self._draggedElement = el
			self._draggedInstance = inst
			self._dragStartMousePos = input.Position
			self._dragStartElementPos = getElementVirtualPixelPos(self, el)

			local endConn
			endConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					self._isDragging = false
					self._draggedElement = nil
					self._draggedInstance = nil
					hideSnapLine(self, "X")
					hideSnapLine(self, "Y")
					self:SaveState()
					self:refreshViewport()
					self:refreshDetails()
					endConn:Disconnect()
				end
			end)
		end
	end)
end

function UiDesigner:refreshDetails()
	-- Refresh properties scroll
	for _, child in self._propertiesScroll:GetChildren() do
		if child:IsA("GuiObject") then child:Destroy() end
	end
	-- Refresh events scroll
	for _, child in self._eventsScroll:GetChildren() do
		if child:IsA("GuiObject") then child:Destroy() end
	end

	local el = self._selectedElement
	if not el then
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1, 0, 0, 40)
		label.BackgroundTransparency = 1
		label.Text = "Select an element to view details."
		label.TextColor3 = Color3.fromRGB(100, 120, 150)
		label.TextSize = 11
		label.Font = Enum.Font.Gotham
		label.Parent = self._propertiesScroll
		return
	end

	-- Auto-detect unit mode from element properties
	self._unitMode = getElementUnitMode(el)
	self:updateToggleVisuals()

	-- Helper to render a property row with label + inputs
	local function createField(labelStr, controlWidth, renderControlFunc)
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 30)
		row.BackgroundTransparency = 1
		row.Parent = self._propertiesScroll

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(0.4, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = labelStr
		lbl.TextColor3 = TEXT_COLOR
		lbl.TextSize = 11
		lbl.Font = Enum.Font.GothamMedium
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = row

		local ctrlFrame = Instance.new("Frame")
		ctrlFrame.Size = UDim2.new(0.6, 0, 1, 0)
		ctrlFrame.Position = UDim2.new(0.4, 0, 0, 0)
		ctrlFrame.BackgroundTransparency = 1
		ctrlFrame.Parent = row

		renderControlFunc(ctrlFrame)
	end

	local function makeTextInput(parent, text, onCompleted)
		local input = Instance.new("TextBox")
		input.Size = UDim2.new(1, 0, 0, 24)
		input.Position = UDim2.new(0, 0, 0.5, -12)
		input.BackgroundColor3 = Color3.fromRGB(12, 16, 26)
		input.BorderSizePixel = 0
		input.Text = text or ""
		input.TextColor3 = Color3.fromRGB(230, 240, 255)
		input.TextSize = 11
		input.Font = Enum.Font.Gotham
		input.ClearTextOnFocus = false
		makeCorner(input, 4)
		input.Parent = parent

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(50, 60, 80)
		stroke.Thickness = 1
		stroke.Parent = input

		input.FocusLost:Connect(function()
			onCompleted(input.Text)
		end)
		return input
	end

	local function createToggleField(labelStr, prop)
		createField(labelStr, 0.6, function(parent)
			local cur = el.properties[prop]
			if cur == nil then cur = false end
			
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0, 24, 0, 24)
			btn.Position = UDim2.new(0, 0, 0.5, -12)
			btn.BackgroundColor3 = cur and Color3.fromRGB(35, 75, 125) or Color3.fromRGB(15, 20, 30)
			btn.Text = cur and "v" or ""
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			btn.TextSize = 12
			btn.Font = Enum.Font.GothamBold
			makeCorner(btn, 4)
			btn.Parent = parent

			btn.MouseButton1Click:Connect(function()
				el.properties[prop] = not cur
				self:SaveState()
				self:refreshViewport()
				self:refreshDetails()
			end)
		end)
	end

	local function createColorField(labelStr, prop)
		createField(labelStr, 0.6, function(parent)
			local cur = el.properties[prop] or {255, 255, 255}
			
			local colorBtn = Instance.new("TextButton")
			colorBtn.Size = UDim2.new(0, 35, 0, 24)
			colorBtn.Position = UDim2.new(0, 0, 0.5, -12)
			colorBtn.BackgroundColor3 = Color3.fromRGB(cur[1], cur[2], cur[3])
			colorBtn.Text = ""
			makeCorner(colorBtn, 4)
			colorBtn.Parent = parent
			
			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(50, 60, 80)
			stroke.Thickness = 1
			stroke.Parent = colorBtn

			local valueInput = Instance.new("TextBox")
			valueInput.Size = UDim2.new(1, -45, 0, 24)
			valueInput.Position = UDim2.new(0, 42, 0.5, -12)
			valueInput.BackgroundTransparency = 1
			valueInput.Text = string.format("%d,%d,%d", cur[1], cur[2], cur[3])
			valueInput.TextColor3 = Color3.fromRGB(130, 150, 180)
			valueInput.TextSize = 10
			valueInput.Font = Enum.Font.Code
			valueInput.TextXAlignment = Enum.TextXAlignment.Left
			valueInput.ClearTextOnFocus = false
			valueInput.Parent = parent

			valueInput.FocusLost:Connect(function()
				local text = valueInput.Text
				local parsed = parseColor(text)
				if parsed then
					el.properties[prop] = parsed
					self:SaveState()
					self:refreshViewport()
					self:refreshDetails()
				else
					valueInput.Text = string.format("%d,%d,%d", cur[1], cur[2], cur[3])
				end
			end)

			colorBtn.MouseButton1Click:Connect(function()
				if self._activeColorPickers then
					for _, picker in ipairs(self._activeColorPickers) do
						if picker and picker.Parent then
							picker:Destroy()
						end
					end
					table.clear(self._activeColorPickers)
				else
					self._activeColorPickers = {}
				end
				self._activeSliderDrag = nil

				local _saved = el.properties[prop] or cur
				local currentR = _saved[1] or cur[1]
				local currentG = _saved[2] or cur[2]
				local currentB = _saved[3] or cur[3]

				local pickerFrame = Instance.new("Frame")
				pickerFrame.Name = "ColorPickerPopup"
				pickerFrame.Size = UDim2.new(0, 200, 0, 200)
				pickerFrame.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
				pickerFrame.ZIndex = 2000
				pickerFrame.Active = true
				makeCorner(pickerFrame, 6)
				
				local pStroke = Instance.new("UIStroke")
				pStroke.Color = Color3.fromRGB(50, 70, 110)
				pStroke.Thickness = 1
				pStroke.Parent = pickerFrame

				local listLayout = Instance.new("UIListLayout")
				listLayout.Padding = UDim.new(0, 8)
				listLayout.SortOrder = Enum.SortOrder.LayoutOrder
				listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
				listLayout.Parent = pickerFrame

				local pad = Instance.new("UIPadding")
				pad.PaddingTop = UDim.new(0, 8)
				pad.PaddingBottom = UDim.new(0, 8)
				pad.PaddingLeft = UDim.new(0, 8)
				pad.PaddingRight = UDim.new(0, 8)
				pad.Parent = pickerFrame

				local swatchesFrame = Instance.new("Frame")
				swatchesFrame.Size = UDim2.new(1, 0, 0, 100)
				swatchesFrame.BackgroundTransparency = 1
				swatchesFrame.LayoutOrder = 1
				swatchesFrame.Parent = pickerFrame

				local grid = Instance.new("UIGridLayout")
				grid.CellSize = UDim2.fromOffset(21, 21)
				grid.CellPadding = UDim2.fromOffset(6, 4)
				grid.SortOrder = Enum.SortOrder.LayoutOrder
				grid.Parent = swatchesFrame

				local overlay = Instance.new("TextButton")
				overlay.Name = "ColorPickerOverlay"
				overlay.Size = UDim2.new(1, 0, 1, 0)
				overlay.BackgroundTransparency = 1
				overlay.Text = ""
				overlay.ZIndex = 1999
				overlay.Parent = self._frame
				self._overlay = overlay

				overlay.MouseButton1Click:Connect(function()
					self._activeSliderDrag = nil
					pickerFrame:Destroy()
					overlay:Destroy()
					self._overlay = nil
				end)

				local function createSlider(name, labelText, labelColor, trackColor, fillColor, initialVal, layoutOrder, onChanged)
					local sFrame = Instance.new("Frame")
					sFrame.Size = UDim2.new(1, 0, 0, 20)
					sFrame.BackgroundTransparency = 1
					sFrame.ZIndex = 2001
					sFrame.LayoutOrder = layoutOrder
					sFrame.Parent = pickerFrame

					local sLabel = Instance.new("TextLabel")
					sLabel.Size = UDim2.new(0, 15, 1, 0)
					sLabel.BackgroundTransparency = 1
					sLabel.Text = labelText
					sLabel.TextColor3 = labelColor
					sLabel.TextSize = 10
					sLabel.Font = Enum.Font.GothamBold
					sLabel.ZIndex = 2001
					sLabel.Parent = sFrame

					local sTrack = Instance.new("Frame")
					sTrack.Size = UDim2.new(1, -55, 0, 4)
					sTrack.Position = UDim2.new(0, 20, 0.5, -2)
					sTrack.BackgroundColor3 = trackColor
					sTrack.BorderSizePixel = 0
					sTrack.ZIndex = 2001
					makeCorner(sTrack, 2)
					sTrack.Parent = sFrame

					local sFill = Instance.new("Frame")
					sFill.Size = UDim2.new(initialVal / 255, 0, 1, 0)
					sFill.BackgroundColor3 = fillColor
					sFill.BorderSizePixel = 0
					sFill.ZIndex = 2001
					makeCorner(sFill, 2)
					sFill.Parent = sTrack

					local sHandle = Instance.new("TextButton")
					sHandle.Size = UDim2.fromOffset(10, 10)
					sHandle.AnchorPoint = Vector2.new(0.5, 0.5)
					sHandle.Position = UDim2.new(initialVal / 255, 0, 0.5, 0)
					sHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					sHandle.BorderSizePixel = 0
					sHandle.Text = ""
					sHandle.Active = true
					sHandle.ZIndex = 2002
					makeCorner(sHandle, 5)
					sHandle.Parent = sTrack

					local sVal = Instance.new("TextLabel")
					sVal.Size = UDim2.new(0, 30, 1, 0)
					sVal.Position = UDim2.new(1, -30, 0, 0)
					sVal.BackgroundTransparency = 1
					sVal.Text = tostring(initialVal)
					sVal.TextColor3 = TEXT_COLOR
					sVal.TextSize = 10
					sVal.Font = Enum.Font.Code
					sVal.TextXAlignment = Enum.TextXAlignment.Right
					sVal.ZIndex = 2001
					sVal.Parent = sFrame

					local function updateVal(mouseX)
						local relativeX = mouseX - sTrack.AbsolutePosition.X
						local pct = math.clamp(relativeX / sTrack.AbsoluteSize.X, 0, 1)
						sHandle.Position = UDim2.new(pct, 0, 0.5, 0)
						sFill.Size = UDim2.new(pct, 0, 1, 0)
						local val = math.round(pct * 255)
						sVal.Text = tostring(val)
						onChanged(val)
					end

					local function startDrag(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							self._activeSliderDrag = {
								track = sTrack,
								sHandle = sHandle,
								sFill = sFill,
								sVal = sVal,
								onChanged = onChanged
							}
							updateVal(input.Position.X)

							local dragConn
							local releaseConn

							dragConn = UserInputService.InputChanged:Connect(function(moveInput)
								if moveInput.UserInputType == Enum.UserInputType.MouseMovement then
									updateVal(moveInput.Position.X)
								end
							end)

							releaseConn = input.Changed:Connect(function()
								if input.UserInputState == Enum.UserInputState.End then
									if self._activeSliderDrag and self._activeSliderDrag.track == sTrack then
										self._activeSliderDrag = nil
									end
									if dragConn then dragConn:Disconnect() end
									if releaseConn then releaseConn:Disconnect() end
								end
							end)
						end
					end

					sHandle.InputBegan:Connect(startDrag)
					sTrack.InputBegan:Connect(startDrag)

					local function updateFromExternal(val)
						local pct = val / 255
						sHandle.Position = UDim2.new(pct, 0, 0.5, 0)
						sFill.Size = UDim2.new(pct, 0, 1, 0)
						sVal.Text = tostring(val)
					end
					
					return updateFromExternal
				end

				local updateRSlider, updateGSlider, updateBSlider

				local function updateLiveColor()
					el.properties[prop] = {currentR, currentG, currentB}
					self:SaveState()
					self:refreshViewport()
					
					colorBtn.BackgroundColor3 = Color3.fromRGB(currentR, currentG, currentB)
					valueInput.Text = string.format("%d,%d,%d", currentR, currentG, currentB)
				end

				updateRSlider = createSlider("R", "R", Color3.fromRGB(240, 100, 100), Color3.fromRGB(60, 30, 30), Color3.fromRGB(230, 75, 75), currentR, 2, function(v)
					currentR = v
					updateLiveColor()
				end)

				updateGSlider = createSlider("G", "G", Color3.fromRGB(100, 240, 100), Color3.fromRGB(30, 60, 30), Color3.fromRGB(75, 230, 75), currentG, 3, function(v)
					currentG = v
					updateLiveColor()
				end)

				updateBSlider = createSlider("B", "B", Color3.fromRGB(100, 150, 240), Color3.fromRGB(30, 45, 75), Color3.fromRGB(75, 140, 230), currentB, 4, function(v)
					currentB = v
					updateLiveColor()
				end)

				for idx, color in ipairs(PREMIUM_SWATCHES) do
					local swatch = Instance.new("TextButton")
					swatch.Size = UDim2.fromOffset(21, 21)
					swatch.BackgroundColor3 = color
					swatch.Text = ""
					swatch.AutoButtonColor = true
					swatch.LayoutOrder = idx
					swatch.ZIndex = 2001
					makeCorner(swatch, 3)
					swatch.Parent = swatchesFrame

					local swatchStroke = Instance.new("UIStroke")
					swatchStroke.Color = Color3.fromRGB(0, 0, 0)
					swatchStroke.Thickness = 0.5
					swatchStroke.Parent = swatch

					swatch.MouseButton1Click:Connect(function()
						currentR = math.round(color.R * 255)
						currentG = math.round(color.G * 255)
						currentB = math.round(color.B * 255)
						updateRSlider(currentR)
						updateGSlider(currentG)
						updateBSlider(currentB)
						updateLiveColor()
						pickerFrame:Destroy()
						if self._overlay then
							self._overlay:Destroy()
							self._overlay = nil
						end
					end)
				end

				local absPos = colorBtn.AbsolutePosition - self._frame.AbsolutePosition
				local posX = math.clamp(absPos.X - 100, 10, self._frame.AbsoluteSize.X - 210)
				local posY = math.clamp(absPos.Y + 28, 10, self._frame.AbsoluteSize.Y - 220)
				pickerFrame.Position = UDim2.fromOffset(posX, posY)
				pickerFrame.Parent = self._frame

				table.insert(self._activeColorPickers, pickerFrame)
			end)
		end)
	end

	local function createChoiceField(labelStr, prop, choices)
		createField(labelStr, 0.6, function(parent)
			local curVal = el.properties[prop] or choices[1]
			
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1, 0, 0, 24)
			btn.Position = UDim2.new(0, 0, 0.5, -12)
			btn.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
			btn.BorderSizePixel = 0
			btn.Text = "  " .. tostring(curVal)
			btn.TextColor3 = Color3.fromRGB(230, 240, 255)
			btn.TextSize = 11
			btn.Font = Enum.Font.GothamMedium
			btn.TextXAlignment = Enum.TextXAlignment.Left
			makeCorner(btn, 4)
			btn.Parent = parent

			local stroke = Instance.new("UIStroke")
			stroke.Color = Color3.fromRGB(50, 60, 80)
			stroke.Thickness = 1
			stroke.Parent = btn

			local arrow = Instance.new("TextLabel")
			arrow.Size = UDim2.new(0, 20, 1, 0)
			arrow.Position = UDim2.new(1, -20, 0, 0)
			arrow.BackgroundTransparency = 1
			arrow.Text = "v"
			arrow.TextColor3 = Color3.fromRGB(100, 120, 160)
			arrow.TextSize = 9
			arrow.Font = Enum.Font.GothamBold
			arrow.Parent = btn

			btn.MouseButton1Click:Connect(function()
				local targetPos = btn.AbsolutePosition
				ChoiceModal.prompt(self._widget, labelStr, choices, function(selected)
					el.properties[prop] = selected
					self:SaveState()
					self:refreshViewport()
					self:refreshDetails()
				end, targetPos)
			end)
		end)
	end

	local function createNumericField(labelStr, prop, defaultValue)
		createField(labelStr, 0.6, function(parent)
			local curVal = el.properties[prop]
			if curVal == nil then curVal = defaultValue end
			
			makeTextInput(parent, tostring(curVal), function(newText)
				local val = tonumber(newText) or defaultValue
				el.properties[prop] = val
				self:SaveState()
				self:refreshViewport()
			end)
		end)
	end

	-- Variable Name
	createField("Name", 0.6, function(parent)
		makeTextInput(parent, el.name, function(newVal)
			local validated = newVal:gsub("%s+", ""):gsub("[^%w_]", "")
			if validated == "" then validated = el.class end
			if validated:match("^%d") then validated = "_" .. validated end
			
			local keywords = {
				["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true,
				["elseif"] = true, ["end"] = true, ["false"] = true, ["for"] = true,
				["function"] = true, ["if"] = true, ["in"] = true, ["local"] = true,
				["nil"] = true, ["not"] = true, ["or"] = true, ["repeat"] = true,
				["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
				["while"] = true
			}
			if keywords[validated] then validated = "_" .. validated end
			
			if validated ~= el.name then
				local nameExists = false
				local function checkName(list)
					for _, item in ipairs(list) do
						if item ~= el and item.name == validated then nameExists = true; break end
						if item.children then checkName(item.children) end
					end
				end
				checkName(self._uiElements)

				if not nameExists then
					if self._currentGraph then
						for _, node in pairs(self._currentGraph.nodes) do
							if node.Class and string.sub(node.Class, 1, 8) == "UIEvent:" then
								local parts = string.split(node.Class, ":")
								if parts[2] == el.name then
									parts[2] = validated
									node.Class = table.concat(parts, ":")
									node:editTitle(parts[2] .. " " .. (parts[3] or "Event"))
									node.OnPinsChanged:Fire()
								end
							end
						end
					end
					el.name = validated
					self:SaveState()
				end
			end
			self:refreshHierarchy()
			self:refreshViewport()
		end)
	end)

	-- Size
	createField("Size X (S, O)", 0.6, function(parent)
		local cur = el.properties.Size or {0, 100, 0, 100}
		local inpS = makeTextInput(parent, tostring(cur[1]), function(v)
			cur[1] = tonumber(v) or 0
			el.properties.Size = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpS.Size = UDim2.new(0.45, 0, 0, 24)

		local inpO = makeTextInput(parent, tostring(cur[2]), function(v)
			cur[2] = tonumber(v) or 0
			el.properties.Size = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpO.Size = UDim2.new(0.45, 0, 0, 24)
		inpO.Position = UDim2.new(0.55, 0, 0.5, -12)
	end)

	createField("Size Y (S, O)", 0.6, function(parent)
		local cur = el.properties.Size or {0, 100, 0, 100}
		local inpS = makeTextInput(parent, tostring(cur[3]), function(v)
			cur[3] = tonumber(v) or 0
			el.properties.Size = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpS.Size = UDim2.new(0.45, 0, 0, 24)

		local inpO = makeTextInput(parent, tostring(cur[4]), function(v)
			cur[4] = tonumber(v) or 0
			el.properties.Size = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpO.Size = UDim2.new(0.45, 0, 0, 24)
		inpO.Position = UDim2.new(0.55, 0, 0.5, -12)
	end)

	-- Position
	createField("Pos X (S, O)", 0.6, function(parent)
		local cur = el.properties.Position or {0, 0, 0, 0}
		local inpS = makeTextInput(parent, tostring(cur[1]), function(v)
			cur[1] = tonumber(v) or 0
			el.properties.Position = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpS.Size = UDim2.new(0.45, 0, 0, 24)

		local inpO = makeTextInput(parent, tostring(cur[2]), function(v)
			cur[2] = tonumber(v) or 0
			el.properties.Position = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpO.Size = UDim2.new(0.45, 0, 0, 24)
		inpO.Position = UDim2.new(0.55, 0, 0.5, -12)
	end)

	createField("Pos Y (S, O)", 0.6, function(parent)
		local cur = el.properties.Position or {0, 0, 0, 0}
		local inpS = makeTextInput(parent, tostring(cur[3]), function(v)
			cur[3] = tonumber(v) or 0
			el.properties.Position = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpS.Size = UDim2.new(0.45, 0, 0, 24)

		local inpO = makeTextInput(parent, tostring(cur[4]), function(v)
			cur[4] = tonumber(v) or 0
			el.properties.Position = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpO.Size = UDim2.new(0.45, 0, 0, 24)
		inpO.Position = UDim2.new(0.55, 0, 0.5, -12)
	end)

	-- Anchor Point
	createField("Anchor (X, Y)", 0.6, function(parent)
		local cur = el.properties.AnchorPoint or {0, 0}
		local inpX = makeTextInput(parent, tostring(cur[1]), function(v)
			cur[1] = tonumber(v) or 0
			el.properties.AnchorPoint = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpX.Size = UDim2.new(0.45, 0, 0, 24)

		local inpY = makeTextInput(parent, tostring(cur[2]), function(v)
			cur[2] = tonumber(v) or 0
			el.properties.AnchorPoint = cur
			self:SaveState()
			self:refreshViewport()
		end)
		inpY.Size = UDim2.new(0.45, 0, 0, 24)
		inpY.Position = UDim2.new(0.55, 0, 0.5, -12)
	end)

	-- Anchor Preset
	createField("Anchor Preset", 0.6, function(parent)
		local curAnchor = el.properties.AnchorPoint or {0, 0}
		local curPos = el.properties.Position or {0, 0, 0, 0}
		local detectedPreset = "Custom"
		
		local presets = {
			{ name = "Top Left", anchor = {0, 0}, posScale = {0, 0} },
			{ name = "Top Center", anchor = {0.5, 0}, posScale = {0.5, 0} },
			{ name = "Top Right", anchor = {1, 0}, posScale = {1, 0} },
			{ name = "Center Left", anchor = {0, 0.5}, posScale = {0, 0.5} },
			{ name = "Center", anchor = {0.5, 0.5}, posScale = {0.5, 0.5} },
			{ name = "Center Right", anchor = {1, 0.5}, posScale = {1, 0.5} },
			{ name = "Bottom Left", anchor = {0, 1}, posScale = {0, 1} },
			{ name = "Bottom Center", anchor = {0.5, 1}, posScale = {0.5, 1} },
			{ name = "Bottom Right", anchor = {1, 1}, posScale = {1, 1} }
		}
		
		for _, p in ipairs(presets) do
			if math.abs(curAnchor[1] - p.anchor[1]) < 0.01 and math.abs(curAnchor[2] - p.anchor[2]) < 0.01 then
				if math.abs(curPos[1] - p.posScale[1]) < 0.01 and math.abs(curPos[3] - p.posScale[2]) < 0.01 then
					detectedPreset = p.name
					break
				end
			end
		end
		
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, 0, 0, 24)
		btn.Position = UDim2.new(0, 0, 0.5, -12)
		btn.BackgroundColor3 = Color3.fromRGB(24, 30, 48)
		btn.BorderSizePixel = 0
		btn.Text = "  " .. detectedPreset
		btn.TextColor3 = Color3.fromRGB(230, 240, 255)
		btn.TextSize = 11
		btn.Font = Enum.Font.GothamMedium
		btn.TextXAlignment = Enum.TextXAlignment.Left
		makeCorner(btn, 4)
		btn.Parent = parent

		local stroke = Instance.new("UIStroke")
		stroke.Color = Color3.fromRGB(50, 60, 80)
		stroke.Thickness = 1
		stroke.Parent = btn

		local arrow = Instance.new("TextLabel")
		arrow.Size = UDim2.new(0, 20, 1, 0)
		arrow.Position = UDim2.new(1, -20, 0, 0)
		arrow.BackgroundTransparency = 1
		arrow.Text = "v"
		arrow.TextColor3 = Color3.fromRGB(100, 120, 160)
		arrow.TextSize = 9
		arrow.Font = Enum.Font.GothamBold
		arrow.Parent = btn

		btn.MouseButton1Click:Connect(function()
			local targetPos = btn.AbsolutePosition
			local choices = {}
			for _, p in ipairs(presets) do
				table.insert(choices, p.name)
			end
			ChoiceModal.prompt(self._widget, "Anchor Preset", choices, function(selected)
				applyAnchorPreset(self, el, selected)
			end, targetPos)
		end)
	end)

	-- Background & Borders
	createColorField("BG Color", "BackgroundColor3")
	createNumericField("BG Trans.", "BackgroundTransparency", 0)
	createNumericField("Border Size", "BorderSizePixel", 0)
	createColorField("Border Color", "BorderColor3")
	createToggleField("Visible", "Visible")

	-- ScrollingFrame specific properties
	if el.properties.CanvasSize ~= nil then
		createField("Canvas X (S, O)", 0.6, function(parent)
			local cur = el.properties.CanvasSize or {0, 0, 2, 0}
			local inpS = makeTextInput(parent, tostring(cur[1]), function(v)
				cur[1] = tonumber(v) or 0
				el.properties.CanvasSize = cur
				self:SaveState()
				self:refreshViewport()
			end)
			inpS.Size = UDim2.new(0.45, 0, 0, 24)

			local inpO = makeTextInput(parent, tostring(cur[2]), function(v)
				cur[2] = tonumber(v) or 0
				el.properties.CanvasSize = cur
				self:SaveState()
				self:refreshViewport()
			end)
			inpO.Size = UDim2.new(0.45, 0, 0, 24)
			inpO.Position = UDim2.new(0.55, 0, 0.5, -12)
		end)

		createField("Canvas Y (S, O)", 0.6, function(parent)
			local cur = el.properties.CanvasSize or {0, 0, 2, 0}
			local inpS = makeTextInput(parent, tostring(cur[3]), function(v)
				cur[3] = tonumber(v) or 0
				el.properties.CanvasSize = cur
				self:SaveState()
				self:refreshViewport()
			end)
			inpS.Size = UDim2.new(0.45, 0, 0, 24)

			local inpO = makeTextInput(parent, tostring(cur[4]), function(v)
				cur[4] = tonumber(v) or 0
				el.properties.CanvasSize = cur
				self:SaveState()
				self:refreshViewport()
			end)
			inpO.Size = UDim2.new(0.45, 0, 0, 24)
			inpO.Position = UDim2.new(0.55, 0, 0.5, -12)
		end)

		createNumericField("Scroll Size", "ScrollBarThickness", 12)
		createColorField("Scroll Color", "ScrollBarImageColor3")
	end

	-- Text specific properties
	if el.properties.Text ~= nil then
		createField("Text", 0.6, function(parent)
			makeTextInput(parent, el.properties.Text, function(v)
				el.properties.Text = v
				self:SaveState()
				self:refreshViewport()
			end)
		end)

		createColorField("Text Color", "TextColor3")
		createNumericField("Text Size", "TextSize", 14)
		createNumericField("Text Trans.", "TextTransparency", 0)
		createToggleField("Text Wrapped", "TextWrapped")
		createChoiceField("Font", "Font", FONTS)
		createChoiceField("Align X", "TextXAlignment", {"Left", "Center", "Right"})
		createChoiceField("Align Y", "TextYAlignment", {"Top", "Center", "Bottom"})
	end

	if el.properties.PlaceholderText ~= nil then
		createField("Placeholder", 0.6, function(parent)
			makeTextInput(parent, el.properties.PlaceholderText, function(v)
				el.properties.PlaceholderText = v
				self:SaveState()
				self:refreshViewport()
			end)
		end)
	end

	-- Image specific properties
	if el.properties.Image ~= nil then
		createField("Image", 0.6, function(parent)
			makeTextInput(parent, el.properties.Image, function(v)
				el.properties.Image = v
				self:SaveState()
				self:refreshViewport()
			end)
		end)

		createNumericField("Image Trans.", "ImageTransparency", 0)
	end

	-- Events
	local eventsList = SUPPORTED_EVENTS[el.class] or {}
	for _, evName in ipairs(eventsList) do
		local row = Instance.new("Frame")
		row.Size = UDim2.new(1, 0, 0, 30)
		row.BackgroundTransparency = 1
		row.Parent = self._eventsScroll

		local lbl = Instance.new("TextLabel")
		lbl.Size = UDim2.new(0.7, 0, 1, 0)
		lbl.BackgroundTransparency = 1
		lbl.Text = "  " .. evName
		lbl.TextColor3 = TEXT_COLOR
		lbl.TextSize = 11
		lbl.Font = Enum.Font.GothamMedium
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.Parent = row

		local addBtn = Instance.new("TextButton")
		addBtn.Size = UDim2.new(0, 50, 0, 20)
		addBtn.Position = UDim2.new(1, -52, 0.5, -10)
		addBtn.BackgroundColor3 = Color3.fromRGB(30, 110, 60)
		addBtn.BorderSizePixel = 0
		addBtn.Text = " + "
		addBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		addBtn.TextSize = 12
		addBtn.Font = Enum.Font.GothamBold
		addBtn.AutoButtonColor = true
		makeCorner(addBtn, 4)
		addBtn.Parent = row

		addBtn.MouseButton1Click:Connect(function()
			self:addOrFocusEvent(el, evName)
		end)
	end
end

function UiDesigner:addOrFocusEvent(el, evName)
	if not self._currentGraph or not self._onSwitchToGraph then return end

	local nodeClass = "UIEvent:" .. el.name .. ":" .. evName
	local existingNode = nil
	for _, node in pairs(self._currentGraph.nodes) do
		if node.Class == nodeClass then
			existingNode = node
			break
		end
	end

	if existingNode then
		-- Just redirect and focus on the node
		self._onSwitchToGraph(existingNode)
	else
		-- Create a new event node on the graph
		local Nodes = require(script.Parent.Parent.Parent.Shared.nodes.events.UIEvent)
		local nodeInstance = Nodes.new(nodeClass)
		
		-- Position it slightly offset from screen center, finding an empty spot
		local spawnX, spawnY = 100, 100
		local isOccupied = true
		while isOccupied do
			isOccupied = false
			for _, node in pairs(self._currentGraph.nodes) do
				local pos = node.Position
				-- Check if there is already a node very close to this spawn position
				if pos and math.abs(pos.X - spawnX) < 50 and math.abs(pos.Y - spawnY) < 50 then
					isOccupied = true
					-- Move down by 120 pixels to avoid overlapping (typical node height)
					spawnY = spawnY + 120
					break
				end
			end
		end

		nodeInstance:editPosition(Vector2.new(spawnX, spawnY))
		self._currentGraph:add_node(nodeInstance)

		self._onSwitchToGraph(nodeInstance)
	end
end

function UiDesigner:GetInstance()
	return self._frame
end

return UiDesigner
