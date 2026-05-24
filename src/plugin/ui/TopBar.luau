-- TopBar : a generic horizontal action bar
local Button = require(script.Parent.Button)

local SegmentedToggle = {}
SegmentedToggle.__index = SegmentedToggle

function SegmentedToggle.new(parent, name, options)
	local self = setmetatable({}, SegmentedToggle)

	local container = Instance.new("Frame")
	container.Name = name
	container.Size = UDim2.new(0, 240, 0, 26)
	container.BackgroundColor3 = Color3.fromRGB(18, 22, 34)
	container.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = container

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(40, 50, 72)
	stroke.Thickness = 1
	stroke.Parent = container

	container.Parent = parent
	self._container = container
	self._buttons = {}
	self._callbacks = {}
	self._selected = nil

	local numOptions = #options
	for i, opt in ipairs(options) do
		local btn = Instance.new("TextButton")
		btn.Name = opt .. "Btn"
		
		local pct = 1 / numOptions
		btn.Size = UDim2.new(pct, -3, 1, -4)
		btn.Position = UDim2.new(pct * (i - 1), (i == 1) and 2 or 1, 0, 2)
		
		btn.BackgroundColor3 = Color3.fromRGB(30, 80, 200)
		btn.BackgroundTransparency = 1
		btn.BorderSizePixel = 0
		btn.Text = opt
		btn.TextColor3 = Color3.fromRGB(140, 175, 220)
		btn.TextSize = 11
		btn.Font = Enum.Font.GothamBold
		btn.AutoButtonColor = false

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 3)
		btnCorner.Parent = btn

		btn.Parent = container
		self._buttons[opt] = btn

		btn.MouseEnter:Connect(function()
			if self._selected ~= opt then
				btn.BackgroundTransparency = 0.5
				btn.BackgroundColor3 = Color3.fromRGB(24, 28, 42)
				btn.TextColor3 = Color3.fromRGB(255, 255, 255)
			end
		end)
		btn.MouseLeave:Connect(function()
			if self._selected ~= opt then
				btn.BackgroundTransparency = 1
				btn.TextColor3 = Color3.fromRGB(140, 175, 220)
			end
		end)

		btn.MouseButton1Click:Connect(function()
			self:Select(opt)
			for _, cb in ipairs(self._callbacks) do
				task.spawn(cb, opt)
			end
		end)
	end

	return self
end

function SegmentedToggle:Select(option)
	self._selected = option
	for opt, btn in pairs(self._buttons) do
		if opt == option then
			btn.BackgroundTransparency = 0
			btn.BackgroundColor3 = Color3.fromRGB(30, 80, 200)
			btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			btn.BackgroundTransparency = 1
			btn.TextColor3 = Color3.fromRGB(140, 175, 220)
		end
	end
end

function SegmentedToggle:OnToggle(callback)
	table.insert(self._callbacks, callback)
end

function SegmentedToggle:SetVisible(visible)
	self._container.Visible = visible
end

function SegmentedToggle:GetVisible()
	return self._container.Visible
end

function SegmentedToggle:GetInstance()
	return self._container
end


local TopBar = {}
TopBar.__index = TopBar

function TopBar.new(parent)
	local self = setmetatable({}, TopBar)

	-- Outer wrapper: holds the border line (no layout here)
	local wrapper = Instance.new("Frame")
	wrapper.Name = "TopBar"
	wrapper.Size = UDim2.new(1, 0, 0, 40)
	wrapper.Position = UDim2.new(0, 0, 0, 0)
	wrapper.BackgroundColor3 = Color3.fromRGB(12, 16, 24)
	wrapper.BorderSizePixel = 0
	wrapper.ZIndex = 3
	wrapper.Parent = parent

	-- Bottom border (not in a layout, so won't push buttons)
	local border = Instance.new("Frame")
	border.Name = "Border"
	border.Size = UDim2.new(1, 0, 0, 1)
	border.Position = UDim2.new(0, 0, 1, -1)
	border.BackgroundColor3 = Color3.fromRGB(40, 50, 72)
	border.BorderSizePixel = 0
	border.Parent = wrapper

	-- Inner container: holds the buttons via UIListLayout (restricted width to avoid overlap)
	local inner = Instance.new("Frame")
	inner.Name = "ButtonRow"
	inner.Size = UDim2.new(1, -250, 1, 0)
	inner.BackgroundTransparency = 1
	inner.Parent = wrapper

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, 6)
	layout.Parent = inner

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.Parent = inner

	-- Right container: holds right-aligned buttons (Design/Graph toggles)
	local rightInner = Instance.new("Frame")
	rightInner.Name = "RightButtonRow"
	rightInner.Size = UDim2.new(0, 300, 1, 0)
	rightInner.Position = UDim2.new(1, -308, 0, 0)
	rightInner.BackgroundTransparency = 1
	rightInner.Parent = wrapper

	local rightLayout = Instance.new("UIListLayout")
	rightLayout.FillDirection = Enum.FillDirection.Horizontal
	rightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
	rightLayout.Padding = UDim.new(0, 6)
	rightLayout.Parent = rightInner

	local rightPadding = Instance.new("UIPadding")
	rightPadding.PaddingRight = UDim.new(0, 8)
	rightPadding.Parent = rightInner

	self._wrapper = wrapper
	self._inner   = inner
	self._rightInner = rightInner
	self._buttons = {}

	return self
end

function TopBar:AddButton(name, label, style)
	local btn = Button.new(self._inner, name, label, style)
	self._buttons[name] = btn
	return btn
end

function TopBar:AddRightButton(name, label, style)
	local btn = Button.new(self._rightInner, name, label, style)
	self._buttons[name] = btn
	return btn
end

function TopBar:AddSeparator(layoutOrder)
	local sep = Instance.new("Frame")
	sep.Name = "Separator_" .. layoutOrder
	sep.Size = UDim2.new(0, 1, 0, 16)
	sep.BackgroundColor3 = Color3.fromRGB(40, 50, 72)
	sep.BorderSizePixel = 0
	sep.LayoutOrder = layoutOrder
	sep.Parent = self._inner
	return sep
end

function TopBar:AddSegmentedToggle(name, options)
	local toggle = SegmentedToggle.new(self._rightInner, name, options)
	self._buttons[name] = toggle
	return toggle
end

function TopBar:GetButton(name)
	return self._buttons[name]
end

function TopBar:GetInstance()
	return self._wrapper
end

return TopBar