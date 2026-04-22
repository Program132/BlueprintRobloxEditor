-- TopBar : a generic horizontal action bar
local Button = require(script.Parent.Button)

local TopBar = {}
TopBar.__index = TopBar

function TopBar.new(parent)
	local self = setmetatable({}, TopBar)

	-- Outer wrapper: holds the border line (no layout here)
	local wrapper = Instance.new("Frame")
	wrapper.Name = "TopBar"
	wrapper.Size = UDim2.new(1, 0, 0, 40)
	wrapper.Position = UDim2.new(0, 0, 0, 0)
	wrapper.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
	wrapper.BorderSizePixel = 0
	wrapper.ZIndex = 3
	wrapper.Parent = parent

	-- Bottom border (not in a layout, so won't push buttons)
	local border = Instance.new("Frame")
	border.Name = "Border"
	border.Size = UDim2.new(1, 0, 0, 1)
	border.Position = UDim2.new(0, 0, 1, -1)
	border.BackgroundColor3 = Color3.fromRGB(38, 50, 72)
	border.BorderSizePixel = 0
	border.Parent = wrapper

	-- Inner container: holds the buttons via UIListLayout
	local inner = Instance.new("Frame")
	inner.Name = "ButtonRow"
	inner.Size = UDim2.new(1, 0, 1, 0)
	inner.BackgroundTransparency = 1
	inner.Parent = wrapper

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 6)
	layout.Parent = inner

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.Parent = inner

	self._wrapper = wrapper
	self._inner   = inner
	self._buttons = {}

	return self
end

function TopBar:AddButton(name, label)
	local btn = Button.new(self._inner, name, label)
	self._buttons[name] = btn
	return btn
end

function TopBar:GetButton(name)
	return self._buttons[name]
end

function TopBar:GetInstance()
	return self._wrapper
end

return TopBar