-- Button : wraps a TextButton with a consistent style
local Button = {}
Button.__index = Button

function Button.new(parent, name, label)
	local self = setmetatable({}, Button)

	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 110, 0, 26)
	btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
	btn.BorderSizePixel = 0
	btn.Text = label
	btn.TextColor3 = Color3.fromRGB(220, 220, 220)
	btn.TextSize = 13
	btn.Font = Enum.Font.GothamMedium
	btn.AutoButtonColor = true

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 4)
	corner.Parent = btn

	btn.Parent = parent
	self._btn = btn

	return self
end

-- Register a click callback
function Button:OnClick(callback)
	self._btn.MouseButton1Click:Connect(callback)
end

-- Get the underlying Instance
function Button:GetInstance()
	return self._btn
end

return Button