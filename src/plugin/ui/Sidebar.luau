-- Sidebar : left panel with collapsible sections (Scripts, Variables)

local Sidebar = {}
Sidebar.__index = Sidebar

local WIDTH = 215

local function makeCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius)
	c.Parent = parent
	return c
end

-- Creates a section block (header + scrollable list)
local function makeSection(parent, title, layoutOrder)
	local section = {}

	local wrapper = Instance.new("Frame")
	wrapper.Name = title .. "Section"
	wrapper.Size = UDim2.new(1, 0, 0, 0)
	wrapper.BackgroundTransparency = 1
	wrapper.AutomaticSize = Enum.AutomaticSize.Y
	wrapper.LayoutOrder = layoutOrder
	wrapper.Parent = parent

	-- Vertical layout INSIDE the wrapper so Header + List stack properly
	local wrapperLayout = Instance.new("UIListLayout")
	wrapperLayout.FillDirection = Enum.FillDirection.Vertical
	wrapperLayout.SortOrder = Enum.SortOrder.LayoutOrder
	wrapperLayout.Padding = UDim.new(0, 0)
	wrapperLayout.Parent = wrapper

	-- ── Header row ────────────────────────────────────────────────────────────
	local header = Instance.new("Frame")
	header.Name = "Header"
	header.Size = UDim2.new(1, 0, 0, 36)
	header.BackgroundTransparency = 1
	header.LayoutOrder = 1
	header.Parent = wrapper

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -44, 1, 0)
	label.Position = UDim2.new(0, 12, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = title
	label.TextColor3 = Color3.fromRGB(190, 205, 230)
	label.TextSize = 13
	label.Font = Enum.Font.GothamSemibold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = header

	local addBtn = Instance.new("TextButton")
	addBtn.Name = "AddBtn"
	addBtn.Size = UDim2.new(0, 22, 0, 22)
	addBtn.Position = UDim2.new(1, -32, 0.5, -11)
	addBtn.BackgroundColor3 = Color3.fromRGB(38, 52, 82)
	addBtn.BorderSizePixel = 0
	addBtn.Text = "+"
	addBtn.TextColor3 = Color3.fromRGB(110, 155, 230)
	addBtn.TextSize = 16
	addBtn.Font = Enum.Font.GothamBold
	addBtn.AutoButtonColor = true
	makeCorner(addBtn, 4)
	addBtn.Parent = header

	-- Separator line (child of header, at the very bottom)
	local sep = Instance.new("Frame")
	sep.Size = UDim2.new(1, -24, 0, 1)
	sep.Position = UDim2.new(0, 12, 1, -1)
	sep.BackgroundColor3 = Color3.fromRGB(35, 45, 65)
	sep.BorderSizePixel = 0
	sep.Parent = header

	-- ── Content list ──────────────────────────────────────────────────────────
	local list = Instance.new("Frame")
	list.Name = "List"
	list.Size = UDim2.new(1, 0, 0, 0)
	list.BackgroundTransparency = 1
	list.AutomaticSize = Enum.AutomaticSize.Y
	list.LayoutOrder = 2
	list.Parent = wrapper

	local listLayout = Instance.new("UIListLayout")
	listLayout.FillDirection = Enum.FillDirection.Vertical
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	listLayout.Padding = UDim.new(0, 2)
	listLayout.Parent = list

	local listPad = Instance.new("UIPadding")
	listPad.PaddingTop = UDim.new(0, 4)
	listPad.PaddingBottom = UDim.new(0, 6)
	listPad.PaddingLeft = UDim.new(0, 8)
	listPad.PaddingRight = UDim.new(0, 8)
	listPad.Parent = list

	section.wrapper = wrapper
	section.list    = list
	section.addBtn  = addBtn
	return section
end

-- ─── Constructor ──────────────────────────────────────────────────────────────

function Sidebar.new(parent)
	local self = setmetatable({}, Sidebar)

	-- Outer frame (holds border + content)
	local frame = Instance.new("Frame")
	frame.Name = "Sidebar"
	frame.Size = UDim2.new(0, WIDTH, 1, -40)
	frame.Position = UDim2.new(0, 0, 0, 40)
	frame.BackgroundColor3 = Color3.fromRGB(16, 21, 34)
	frame.BorderSizePixel = 0
	frame.Parent = parent

	-- Right-edge border
	local border = Instance.new("Frame")
	border.Name = "Border"
	border.Size = UDim2.new(0, 1, 1, 0)
	border.Position = UDim2.new(1, -1, 0, 0)
	border.BackgroundColor3 = Color3.fromRGB(38, 50, 72)
	border.BorderSizePixel = 0
	border.Parent = frame

	-- Scrollable content
	local content = Instance.new("ScrollingFrame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -1, 1, 0)
	content.BackgroundTransparency = 1
	content.BorderSizePixel = 0
	content.ScrollBarThickness = 4
	content.ScrollBarImageColor3 = Color3.fromRGB(50, 65, 95)
	content.AutomaticCanvasSize = Enum.AutomaticSize.Y
	content.CanvasSize = UDim2.new(0, 0, 0, 0)
	content.Parent = frame

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = content

	self._frame     = frame
	self._content   = content
	self._scripts   = makeSection(content, "Scripts",   1)
	self._variables = makeSection(content, "Variables", 2)
	self._varItems  = {}

	return self
end

-- ─── Public API ───────────────────────────────────────────────────────────────

function Sidebar:OnAddScript(callback)
	self._scripts.addBtn.MouseButton1Click:Connect(callback)
end

function Sidebar:OnAddVariable(callback)
	self._variables.addBtn.MouseButton1Click:Connect(callback)
end

-- Adds a variable row to the list: [name]  [GET] [SET] [X]
function Sidebar:AddVariable(name)
	local row = Instance.new("Frame")
	row.Name = "Var_" .. name
	row.Size = UDim2.new(1, 0, 0, 28)
	row.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
	row.BorderSizePixel = 0
	row.Parent = self._variables.list
	makeCorner(row, 4)

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, -120, 1, 0)
	nameLabel.Position = UDim2.new(0, 10, 0, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = name
	nameLabel.TextColor3 = Color3.fromRGB(170, 195, 230)
	nameLabel.TextSize = 12
	nameLabel.Font = Enum.Font.GothamMedium
	nameLabel.TextXAlignment = Enum.TextXAlignment.Left
	nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
	nameLabel.Parent = row

	-- Tag buttons aligned to the right
	local tagBar = Instance.new("Frame")
	tagBar.Size = UDim2.new(0, 105, 1, 0)
	tagBar.Position = UDim2.new(1, -110, 0, 0)
	tagBar.BackgroundTransparency = 1
	tagBar.Parent = row

	local tagLayout = Instance.new("UIListLayout")
	tagLayout.FillDirection = Enum.FillDirection.Horizontal
	tagLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tagLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	tagLayout.Padding = UDim.new(0, 3)
	tagLayout.Parent = tagBar

	local function makeTag(tagLabel, bg, fg)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 30, 0, 20)
		btn.BackgroundColor3 = bg
		btn.BorderSizePixel = 0
		btn.Text = tagLabel
		btn.TextColor3 = fg
		btn.TextSize = 10
		btn.Font = Enum.Font.GothamBold
		btn.AutoButtonColor = true
		makeCorner(btn, 3)
		btn.Parent = tagBar
		return btn
	end

	local getBtn = makeTag("GET", Color3.fromRGB(30, 50, 85), Color3.fromRGB(90, 150, 230))
	local setBtn = makeTag("SET", Color3.fromRGB(30, 50, 85), Color3.fromRGB(90, 150, 230))
	local delBtn = makeTag("X",   Color3.fromRGB(90, 25, 25), Color3.fromRGB(230, 80, 80))

	-- Callbacks
	local handle = {
		name     = name,
		instance = row,
		getBtn   = getBtn,
		setBtn   = setBtn,
	}

	-- GET button: will create a "get" node on the canvas
	getBtn.MouseButton1Click:Connect(function()
		-- TODO: spawn a "get" node for this variable on canvas
		print("[Blueprint] GET node for '" .. name .. "'")
	end)

	-- SET button: will create a "set" node on the canvas
	setBtn.MouseButton1Click:Connect(function()
		-- TODO: spawn a "set" node for this variable on canvas
		print("[Blueprint] SET node for '" .. name .. "'")
	end)

	-- X button: remove this variable
	delBtn.MouseButton1Click:Connect(function()
		row:Destroy()
		for i, item in self._varItems do
			if item.name == name then
				table.remove(self._varItems, i)
				break
			end
		end
	end)

	table.insert(self._varItems, handle)
	return handle
end

function Sidebar:GetWidth()
	return WIDTH
end

function Sidebar:GetInstance()
	return self._frame
end

return Sidebar