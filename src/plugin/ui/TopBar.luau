-- TopBar : a generic horizontal action bar
-- Usage:
--   local bar = TopBar.new(parent)
--   local btn = bar:AddButton("MyBtn", "Click me")
--   btn:OnClick(function() ... end)
local Button = require(script.Parent.Button)

local TopBar = {}
TopBar.__index = TopBar

function TopBar.new(parent)
	local self = setmetatable({}, TopBar)

	local frame = Instance.new("Frame")
	frame.Name = "TopBar"
	frame.Size = UDim2.new(1, 0, 0, 40)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
	frame.BorderSizePixel = 0
	frame.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = Enum.FillDirection.Horizontal
	layout.VerticalAlignment = Enum.VerticalAlignment.Center
	layout.Padding = UDim.new(0, 6)
	layout.Parent = frame

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, 8)
	padding.Parent = frame

	self._frame   = frame
	self._buttons = {}

	return self
end

-- Add a button to the bar and return it
function TopBar:AddButton(name, label)
	local btn = Button.new(self._frame, name, label)
	self._buttons[name] = btn
	return btn
end

-- Retrieve a previously added button by name
function TopBar:GetButton(name)
	return self._buttons[name]
end

function TopBar:GetInstance()
	return self._frame
end

return TopBar